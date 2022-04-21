//
//  CKBundle.swift
//  ClearKeep
//
//  Created by Luan Nguyen on 10/29/20.
//

import Foundation
import SignalProtocolObjC

public enum CKBundleError: Error {
	case unknown
	case notFound
	case invalid
	case keyGeneration
}

class CKBundle: NSObject {
	let deviceId: UInt32
	let registrationId: UInt32
	let identityKey: Data
	let signedPreKey: CKSignedPreKey
	let preKeys: [CKPreKey]
	
	init(deviceId: UInt32,
		 registrationId: UInt32,
		 identityKey: Data,
		 signedPreKey: CKSignedPreKey,
		 preKeys: [CKPreKey]) {
		self.deviceId = deviceId
		self.identityKey = identityKey
		self.signedPreKey = signedPreKey
		self.preKeys = preKeys
		self.registrationId = registrationId
	}
}

extension CKBundle {
	
	/// Returns copy of bundle with new preKeys
	func copyBundle(newPreKeys: [CKPreKey]) -> CKBundle {
		let bundle = CKBundle(deviceId: deviceId,
							  registrationId: registrationId,
							  identityKey: identityKey,
							  signedPreKey: signedPreKey,
							  preKeys: newPreKeys)
		return bundle
	}
	
	/// Returns Signal bundle from a random PreKey
	func signalBundle() throws -> SignalPreKeyBundle {
		let index = Int(arc4random_uniform(UInt32(preKeys.count)))
		let preKey = preKeys[index]
		let preKeyBundle = try SignalPreKeyBundle(registrationId: registrationId,
												  deviceId: deviceId,
												  preKeyId: preKey.preKeyId,
												  preKeyPublic: preKey.publicKey,
												  signedPreKeyId: signedPreKey.preKeyId,
												  signedPreKeyPublic: signedPreKey.publicKey,
												  signature: signedPreKey.signature,
												  identityKey: identityKey)
		return preKeyBundle
	}
	
	convenience init(deviceId: UInt32,
					 registrationId: UInt32,
					 identity: SignalIdentityKeyPair,
					 signedPreKey: SignalSignedPreKey,
					 preKeys: [SignalPreKey]) throws {
		
		let ckSignedPreKey = try CKSignedPreKey(signedPreKey: signedPreKey)
		let ckPreKeys = CKPreKey.preKeysFromSignal(preKeys)
		
		// Double check that this bundle is valid
		if let preKey = preKeys.first,
		   let preKeyPublic = preKey.keyPair?.publicKey {
			try SignalPreKeyBundle(registrationId: 0,
								   deviceId: deviceId,
								   preKeyId: preKey.preKeyId,
								   preKeyPublic: preKeyPublic,
								   signedPreKeyId: ckSignedPreKey.preKeyId,
								   signedPreKeyPublic: ckSignedPreKey.publicKey,
								   signature: ckSignedPreKey.signature,
								   identityKey: identity.publicKey)
		} else {
			throw CKBundleError.invalid
		}
		
		self.init(deviceId: deviceId,
				  registrationId: registrationId,
				  identityKey: identity.publicKey,
				  signedPreKey: ckSignedPreKey,
				  preKeys: ckPreKeys)
	}
	
	convenience init(identity: CKAccountSignalIdentity,
					 signedPreKey: CKSignalSignedPreKey,
					 preKeys: [CKSignalPreKey]) throws {
		let ckSignedPreKey = try CKSignedPreKey(signedPreKey: signedPreKey)
		
		var ckPreKeys: [CKPreKey] = []
		preKeys.forEach { (preKey) in
			guard let keyData = preKey.keyData, keyData.count > 0 else { return }
			do {
				let signalPreKey = try SignalPreKey(serializedData: keyData)
				guard let publicKey = signalPreKey.keyPair?.publicKey else { return }
				let ckPreKey = CKPreKey(withPreKeyId: preKey.keyId, publicKey: publicKey)
				ckPreKeys.append(ckPreKey)
			} catch let error {
				NSLog("Found invalid prekey: \(error)")
			}
		}
		
		// Double check that this bundle is valid
		if let preKey = preKeys.first, let preKeyData = preKey.keyData,
		   let signalPreKey = try? SignalPreKey(serializedData: preKeyData),
		   let preKeyPublic = signalPreKey.keyPair?.publicKey {
			try SignalPreKeyBundle(registrationId: 0,
								   deviceId: identity.registrationId,
								   preKeyId: preKey.keyId,
								   preKeyPublic: preKeyPublic,
								   signedPreKeyId: ckSignedPreKey.preKeyId,
								   signedPreKeyPublic: ckSignedPreKey.publicKey,
								   signature: ckSignedPreKey.signature,
								   identityKey: identity.identityKeyPair.publicKey)
		} else {
			throw CKBundleError.invalid
		}
		
		self.init(deviceId: identity.registrationId,
				  registrationId: identity.registrationId,
				  identityKey: identity.identityKeyPair.publicKey,
				  signedPreKey: ckSignedPreKey,
				  preKeys: ckPreKeys)
	}
}
