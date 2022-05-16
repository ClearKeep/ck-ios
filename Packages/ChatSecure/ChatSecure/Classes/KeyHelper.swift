//
//  KeyHelper.swift
//  ChatSecure
//
//  Created by Quang Pham on 19/05/2022.
//

import LibSignalClient
import Common

final class KeyHelper {
	class func generatePreKeys(withStartingPreKeyId startingId: Int, count: Int) -> [PreKeyRecord] {
		do {
			var preKeys: [PreKeyRecord] = []
			for value in startingId...count {
				let preKey = try PreKeyRecord.init(id: UInt32(value), privateKey: PrivateKey.generate())
				preKeys.append(preKey)
			}
			return preKeys
		} catch {
			Debug.DLog("generatePreKeys exception: \(error)")
			return []
		}
	}
	
	class func generateSignedPreKeyRecord(withIdentity key: IdentityKeyPair, signedPreKeyId: UInt32) -> SignedPreKeyRecord? {
		do {
			let privateKey = PrivateKey.generate()
			let signedPrekeySignature = key.privateKey.generateSignature(
				message: privateKey.publicKey.serialize()
			)
			let signedPreKeyRecord = try SignedPreKeyRecord.init(
				id: signedPreKeyId,
				timestamp: UInt64(Date().timeIntervalSince1970 * 1000),
				privateKey: privateKey,
				signature: signedPrekeySignature)
			return signedPreKeyRecord
		} catch {
			Debug.DLog("generateSignedPreKeyRecord exception: \(error)")
			return nil
		}
	}
	
	class func generateRegistrationId() -> UInt32 {
		return UInt32.random(in: 0...0x3FFF)
	}
}
