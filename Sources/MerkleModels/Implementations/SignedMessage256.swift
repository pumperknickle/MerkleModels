import Foundation
import CryptoStarterPack
import Bedrock
import Vapor
import FluentPostgreSQL

public struct SignedMessage256: Codable {
    private var rawID: ID?
    private var rawCreatedAt: Date?
	private let rawPublicKey: String?
	private let rawPublicKeyHash: Digest!
	private let rawMessage: EncryptedAddress256!
	private let rawSignature: Signature!
	
	public init(publicKey: String?, publicKeyHash: UInt256, message: EncryptedAddress256, signature: Data!) {
		rawPublicKey = publicKey
		rawPublicKeyHash = publicKeyHash
		rawMessage = message
		rawSignature = signature
	}
}

extension SignedMessage256: SignedMessage {
	public typealias MessageType = EncryptedAddress256
	public typealias AssymetricCrypto = BaseAsymmetric
	public typealias HashDelegate = BaseCrypto
	public typealias Digest = UInt256
	
	public var publicKey: String? { return rawPublicKey }
	public var publicKeyHash: Digest! { return rawPublicKeyHash }
	public var message: EncryptedAddress256! { return rawMessage }
	public var signature: Signature! { return rawSignature }
}

extension SignedMessage256: Model {
    public typealias Database = PostgreSQLDatabase
    public typealias ID = Int
    public static let idKey: IDKey = \.rawID
    public static let createdAtKey: TimestampKey? = \.rawCreatedAt
}

extension SignedMessage256: Content { }

extension SignedMessage256: Parameter { }

extension SignedMessage256: Migration { }
