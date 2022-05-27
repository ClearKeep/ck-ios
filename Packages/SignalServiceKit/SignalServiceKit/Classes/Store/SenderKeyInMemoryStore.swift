//
//  SenderKeyInMemoryStore.swift
//  SignalServiceKit
//
//  Created by Quang Pham on 24/05/2022.
//

import LibSignalClient

public protocol ISenderKeyStore: SenderKeyStore {
	func getSenderDistributionID(from sender: ProtocolAddress, groupId: Int64) -> UUID
}

private struct SenderKeyName: Hashable {
	var sender: ProtocolAddress
	var distributionId: UUID
}

final class SenderKeyInMemoryStore {
	// MARK: - Variables
	private let storage: YapDatabaseManager
	private var senderKeyMap: [SenderKeyName: SenderKeyRecord] = [:]
	private var senderUuidMap: [String: UUID] = [:]
	
	// MARK: - Init
	init(storage: YapDatabaseManager) {
		self.storage = storage
	}
	
	private func getKey(distributionId: UUID, name: String) -> String {
		return distributionId.uuidString + name
	}
}

extension SenderKeyInMemoryStore: ISenderKeyStore {
	func storeSenderKey(from sender: ProtocolAddress, distributionId: UUID, record: SenderKeyRecord, context: StoreContext) throws {
		senderKeyMap[SenderKeyName(sender: sender, distributionId: distributionId)] = record
		let data = Data(record.serialize())
		storage.insert(data, forKey: getKey(distributionId: distributionId, name: sender.name))
	}
	
	func loadSenderKey(from sender: ProtocolAddress, distributionId: UUID, context: StoreContext) throws -> SenderKeyRecord? {
		if let record = senderKeyMap[SenderKeyName(sender: sender, distributionId: distributionId)] {
			return record
		} else {
			if let data: Data = storage.object(forKey: getKey(distributionId: distributionId, name: sender.name)) {
				let senderKeyRecord = try SenderKeyRecord(bytes: data)
				senderKeyMap[SenderKeyName(sender: sender, distributionId: distributionId)] = senderKeyRecord
				return senderKeyRecord
			} else {
				return nil
			}
		}
	}
	
	func getSenderDistributionID(from sender: ProtocolAddress, groupId: Int64) -> UUID {
		let key = "\(groupId).\(sender.name)"
		if let existingId = senderUuidMap[key] {
			return existingId
		} else {
			if let persistedString: String = storage.object(forKey: key),
			   let persistedUUID = UUID(uuidString: persistedString) {
				senderUuidMap[key] = persistedUUID
				return persistedUUID
			} else {
				let distributionId = UUID()
				storage.insert(distributionId.uuidString, forKey: key)
				senderUuidMap[key] = distributionId
				return distributionId
			}
		}
	}
}
