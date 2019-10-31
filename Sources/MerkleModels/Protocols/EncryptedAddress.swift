import Foundation
import Bedrock
import CryptoStarterPack
import AwesomeDictionary

public protocol EncryptedAddress: BinaryEncodable {
	associatedtype AssymetricDelegateType: AsymmetricDelegate
	associatedtype SymmetricDelegateType: SymmetricDelegate
	associatedtype HashDelegateType: CryptoDelegate
	associatedtype Digest: FixedWidthInteger, BinaryEncodable
	
	typealias PublicKey = AssymetricDelegateType.PublicKey
	typealias PrivateKey = AssymetricDelegateType.PrivateKey
	typealias SymmetricKey = SymmetricDelegateType.Key
	
	var addressHash: Digest! { get }
	var encryptedKeys: Mapping<Digest, Data>? { get }
	
	init(addressHash: Digest, encryptedKeys: Mapping<Digest, Data>?)
}

public extension EncryptedAddress {
	func decryptKey(publicKeyDigest: Digest, privateKey: PrivateKey) -> SymmetricKey? {
		guard let encryptedKeys = encryptedKeys else { return nil }
		guard let ciphertextKey = encryptedKeys[publicKeyDigest] else { return nil }
		guard let plaintextKey = AssymetricDelegateType.decrypt(cipherText: ciphertextKey, privateKey: privateKey) else { return nil }
		return SymmetricKey(data: plaintextKey)
	}
	
	init?(addressHash: Digest, symmetricKey: SymmetricKey, recipients: Mapping<Digest, PublicKey>) {
		let encryptedKeys = recipients.elements().reduce(Mapping<Digest, Data>()) { (result, entry) -> Mapping<Digest, Data>? in
			guard let result = result else { return nil }
			guard let encryptedSymmetricKey = AssymetricDelegateType.encrypt(plainText: symmetricKey.toData(), publicKey: entry.1) else { return nil }
			return result.setting(key: entry.0, value: encryptedSymmetricKey)
		}
		guard let finalEncryptedKeys = encryptedKeys else { return nil }
		self.init(addressHash: addressHash, encryptedKeys: finalEncryptedKeys)
	}
	
	init?(addressHash: Digest, symmetricKey: SymmetricKey, recipientPublicKeys: [PublicKey]) {
		let recipients = recipientPublicKeys.reduce(Mapping<Digest, PublicKey>()) { (result, entry) -> Mapping<Digest, PublicKey>? in
			guard let result = result else { return nil }
			guard let publicKeyHashBinary = HashDelegateType.hash(entry.toBoolArray()) else { return nil }
			guard let publicKeyHash = Digest(raw: publicKeyHashBinary) else { return nil }
			return result.setting(key: publicKeyHash, value: entry)
		}
		guard let finalRecipients = recipients else { return nil }
		self.init(addressHash: addressHash, symmetricKey: symmetricKey, recipients: finalRecipients)
	}
	
	func toBoolArray() -> [Bool] {
		return try! JSONEncoder().encode(self).toBoolArray()
	}
	
	init?(raw: [Bool]) {
		guard let data = Data(raw: raw) else { return nil }
		guard let newObject = try? JSONDecoder().decode(Self.self, from: data) else { return nil }
		self = newObject
	}
}
