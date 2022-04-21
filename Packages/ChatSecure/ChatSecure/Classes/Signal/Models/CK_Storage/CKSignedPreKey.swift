//
//  CKSignedPreKey.swift
//  ClearKeep
//
//  Created by Luan Nguyen on 10/29/20.
//

import Foundation
import SignalProtocolObjC

class CKSignedPreKey: CKPreKey {
	let signature: Data
	
	init(withPreKeyId preKeyId: UInt32, publicKey: Data, signature: Data) {
		self.signature = signature
		super.init(withPreKeyId: preKeyId, publicKey: publicKey)
	}
}

extension CKSignedPreKey {
	convenience init(signedPreKey: CKSignalSignedPreKey) throws {
		let signalSignedPreKey = try SignalSignedPreKey(serializedData: signedPreKey.keyData)
		guard let publicKey = signalSignedPreKey.keyPair?.publicKey else {
			throw CKBundleError.invalid
		}
		self.init(withPreKeyId: signedPreKey.keyId, publicKey: publicKey, signature: signalSignedPreKey.signature)
		
	}
	convenience init(signedPreKey: SignalSignedPreKey) throws {
		guard let publicKey = signedPreKey.keyPair?.publicKey else {
			throw CKBundleError.invalid
		}
		self.init(withPreKeyId: signedPreKey.preKeyId, publicKey: publicKey, signature: signedPreKey.signature)
	}
}
