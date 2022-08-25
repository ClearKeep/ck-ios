//
//  PreKeyInMemoryStore.swift
//  SignalServiceKit
//
//  Created by Quang Pham on 24/05/2022.
//

import LibSignalClient
import Common

public protocol IPreKeyInMemoryStore: PreKeyStore {
	func deletePrekeys(domain: String, clientId: String)
}

final class PreKeyInMemoryStore {
	// MARK: - Variables
	private let storage: YapDatabaseManager
	private let channelStorage: ChannelStorage
	private var prekeyMap: [UInt32: PreKeyRecord] = [:]
	
	// MARK: - Init
	init(storage: YapDatabaseManager, channelStorage: ChannelStorage) {
		self.storage = storage
		self.channelStorage = channelStorage
	}
	
	private func getIndex(preKeyId: UInt32) -> UInt32 {
		let currrentServer = channelStorage.tempServer
		let userId = currrentServer?.ownerClientId ?? channelStorage.currentServer?.ownerClientId ?? ""
		let domain = currrentServer?.serverDomain ?? channelStorage.currentDomain
		let index = ("\(preKeyId)" + domain + userId).hashCode()
		return UInt32(bitPattern: index)
	}
}

extension PreKeyInMemoryStore: IPreKeyInMemoryStore {
	
	func loadPreKey(id: UInt32, context: StoreContext) throws -> PreKeyRecord {
		let index = getIndex(preKeyId: id)
		if let record = prekeyMap[index] {
			return record
		} else {
			if let data: Data = storage.object(forKey: String(index)) {
				let preKeyRecord = try PreKeyRecord(bytes: data)
				prekeyMap[index] = preKeyRecord
				return preKeyRecord
			} else {
				throw SignalError.invalidKeyIdentifier("no prekey with this identifier")
			}
		}
	}
	
	func storePreKey(_ record: PreKeyRecord, id: UInt32, context: StoreContext) throws {
		let index = getIndex(preKeyId: id)
		let recordData = Data(record.serialize())
		prekeyMap[index] = record
		storage.insert(recordData, forKey: String(index))
	}
	
	func removePreKey(id: UInt32, context: StoreContext) throws {
		let index = getIndex(preKeyId: id)
		prekeyMap.removeValue(forKey: index)
	}
	
	func deletePrekeys(domain: String, clientId: String) {
		prekeyMap.removeAll()
		let index = UInt32(bitPattern: ("\(1)" + domain + clientId).hashCode())
		storage.remove(String(index))
	}
}
