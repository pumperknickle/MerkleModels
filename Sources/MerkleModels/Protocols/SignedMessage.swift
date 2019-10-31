import Foundation
import CryptoStarterPack
import Bedrock

public protocol SignedMessage: Codable {
	associatedtype AssymetricCrypto: AsymmetricDelegate
	associatedtype HashDelegate: CryptoDelegate
	associatedtype Digest: FixedWidthInteger, BinaryEncodable
	associatedtype MessageType: BinaryEncodable
	
	typealias PublicKey = AssymetricCrypto.PublicKey
	typealias PrivateKey = AssymetricCrypto.PrivateKey
	typealias Signature = AssymetricCrypto.Signature
	
	var publicKey: PublicKey? { get } // can be ommited for efficiency
	var publicKeyHash: Digest! { get }
	var message: MessageType! { get }
	var signature: Signature! { get } // this can be verified that the publicKey
	
	init(publicKey: PublicKey?, publicKeyHash: Digest, message: MessageType, signature: Signature!)
}

public extension SignedMessage {
	static func create(message: MessageType, privateKey: PrivateKey, publicKey: PublicKey) -> Self? {
		return Self(privateKey: privateKey, publicKey: publicKey, message: message)
	}
	
	func verify(publicKey: PublicKey) -> Bool {
		guard let publicKeyHashBinary = HashDelegate.hash(publicKey.toBoolArray()), let calculatedPublicKeyHash = Digest(raw: publicKeyHashBinary) else { return false }
		if calculatedPublicKeyHash != self.publicKeyHash { return false }
		return AssymetricCrypto.verify(message: message.toBoolArray(), publicKey: publicKey, signature: signature)
	}
	
	init?(privateKey: PrivateKey, publicKey: PublicKey, message: MessageType) {
		guard let publicKeyHashBinary = HashDelegate.hash(publicKey.toBoolArray()), let publicKeyHash = Digest(raw: publicKeyHashBinary) else { return nil }
		guard let signature = AssymetricCrypto.sign(message: message.toBoolArray(), privateKey: privateKey) else { return nil }
		self.init(publicKey: publicKey, publicKeyHash: publicKeyHash, message: message, signature: signature)
	}
}
