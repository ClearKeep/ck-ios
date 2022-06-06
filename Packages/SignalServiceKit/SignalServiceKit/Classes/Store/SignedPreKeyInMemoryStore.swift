//
//  SignedPreKeyInMemoryStore.swift
//  SignalServiceKit
//
//  Created by Quang Pham on 24/05/2022.
//

import LibSignalClient

final class SignedPreKeyInMemoryStore {
	// MARK: - Variables
	private let storage: YapDatabaseManager
	private var signedPrekeyMap: [UInt32: SignedPreKeyRecord] = [:]
	
	// MARK: - Init
	init(storage: YapDatabaseManager) {
		self.storage = storage
	}
}

extension SignedPreKeyInMemoryStore: SignedPreKeyStore {
	
	func loadSignedPreKey(id: UInt32, context: StoreContext) throws -> SignedPreKeyRecord {
        print("load signed prekey with identifier: \(id)")
		if let record = signedPrekeyMap[id] {
			return record
		} else {
			if let data: Data = storage.object(forKey: String(id)) {
				let signedPreKeyRecord = try SignedPreKeyRecord(bytes: data)
				signedPrekeyMap[id] = signedPreKeyRecord
				return signedPreKeyRecord
			} else {
				throw SignalError.invalidKeyIdentifier("no signed prekey with this identifier")
			}
		}
	}
	
	func storeSignedPreKey(_ record: SignedPreKeyRecord, id: UInt32, context: StoreContext) throws {
        print("store signed prekey with identifier: \(id)")
		signedPrekeyMap[id] = record
		let recordData = Data(record.serialize())
		storage.insert(recordData, forKey: String(id))
	}
}
