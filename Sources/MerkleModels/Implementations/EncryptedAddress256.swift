import Foundation
import CryptoStarterPack
import Bedrock
import AwesomeDictionary

public struct EncryptedAddress256: Codable {
	private let rawAddressHash: UInt256!
	private let rawEncryptedKeys: Mapping<UInt256, Data>?
	
	public init(addressHash: UInt256, encryptedKeys: Mapping<UInt256, Data>?) {
		rawAddressHash = addressHash
		rawEncryptedKeys = encryptedKeys
	}
}

extension EncryptedAddress256: EncryptedAddress {
	public typealias AssymetricDelegateType = BaseAsymmetric
	public typealias SymmetricDelegateType = BaseSymmetric
	public typealias HashDelegateType = BaseCrypto
	public typealias Digest = UInt256
	
	public var addressHash: UInt256! { return rawAddressHash }
	public var encryptedKeys: Mapping<UInt256, Data>? { return rawEncryptedKeys }
}
