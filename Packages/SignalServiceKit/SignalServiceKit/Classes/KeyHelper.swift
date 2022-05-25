//
//  CLKKeyHelper.swift
//  SignalServiceKit
//
//  Created by Quang Pham on 20/05/2022.
//

import LibSignalClient

public class KeyHelper {
	public class func generatePreKeys(withStartingPreKeyId startingId: Int, count: Int) -> [PreKeyRecord] {
		do {
			var preKeys: [PreKeyRecord] = []
			for value in startingId...count {
				let preKey = try PreKeyRecord.init(id: UInt32(value), privateKey: PrivateKey.generate())
				preKeys.append(preKey)
			}
			return preKeys
		} catch {
			return []
		}
	}
	
	public class func generateSignedPreKeyRecord(withIdentity key: IdentityKeyPair, signedPreKeyId: UInt32) -> SignedPreKeyRecord? {
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
			return nil
		}
	}
	
	public class func generateIdentityKeyPair() -> IdentityKeyPair {
		return IdentityKeyPair.generate()
	}
	
	public class func generateRegistrationId() -> UInt32 {
		return UInt32.random(in: 0...0x3FFF)
	}
}
