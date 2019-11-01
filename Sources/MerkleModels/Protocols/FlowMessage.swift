import Foundation

public protocol FlowMessage: SignedMessage {
	var flow: String! { get }
	
	init(flow: String, publicKey: PublicKey?, publicKeyHash: Digest, message: MessageType, signature: Signature!)
	func removingPublicKey() -> Self
}

public extension FlowMessage {
	init(publicKey: PublicKey?, publicKeyHash: Digest, message: MessageType, signature: Signature!) {
		self.init(flow: publicKeyHash.toBoolArray().literal(), publicKey: publicKey, publicKeyHash: publicKeyHash, message: message, signature: signature)
	}
	
	func removingPublicKey() -> Self {
		return Self(flow: flow, publicKey: nil, publicKeyHash: publicKeyHash, message: message, signature: signature)
	}
	
	init?(flow: String, privateKey: PrivateKey, publicKey: PublicKey, message: MessageType) {
		guard let publicKeyHash = Self.hash(publicKey: publicKey) else { return nil }
		guard let signature = Self.createSignature(for: message, with: privateKey) else { return nil }
		self.init(flow: flow, publicKey: publicKey, publicKeyHash: publicKeyHash, message: message, signature: signature)
	}
}
