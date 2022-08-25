//
//  SenderKeyInMemoryStore.swift
//  SignalServiceKit
//
//  Created by Quang Pham on 24/05/2022.
//

import LibSignalClient
import Foundation

public protocol ISenderKeyStore: SenderKeyStore {
	func getSenderDistributionID(senderID: String, groupId: Int64, isCreateNew: Bool) -> UUID?
	func removeSenderKey(domain: String)
	func saveSenderDistributionID(senderID: String, groupId: Int64)
}

private struct SenderKeyName: Hashable {
	var sender: ProtocolAddress
	var distributionId: UUID
}

public final class SenderKeyInMemoryStore {
	// MARK: - Variables
	private let storage: YapDatabaseManager
	private var senderKeyMap: [SenderKeyName: SenderKeyRecord] = [:]
	private var senderUuidMap: [String: UUID] = [:]

	// MARK: - Init
	public init(storage: YapDatabaseManager) {
		self.storage = storage
	}
	
	private func getKey(distributionId: UUID, name: String) -> String {
		return distributionId.uuidString + name
	}
}

extension SenderKeyInMemoryStore: ISenderKeyStore {
	public func storeSenderKey(from sender: ProtocolAddress, distributionId: UUID, record: SenderKeyRecord, context: StoreContext) throws {
		senderKeyMap[SenderKeyName(sender: sender, distributionId: distributionId)] = record
		let data = Data(record.serialize())
		let key = getKey(distributionId: distributionId, name: sender.name)
		storage.insert(data, forKey: key, collection: .domain(channelStorage.tempServer?.serverDomain ?? channelStorage.currentDomain))
	}
	
	public func loadSenderKey(from sender: ProtocolAddress, distributionId: UUID, context: StoreContext) throws -> SenderKeyRecord? {
		if let record = senderKeyMap[SenderKeyName(sender: sender, distributionId: distributionId)] {
			return record
		} else {
			let key = getKey(distributionId: distributionId, name: sender.name)
			if let data: Data = storage.object(forKey: key, collection: .domain(channelStorage.tempServer?.serverDomain ?? channelStorage.currentDomain)) {
				let senderKeyRecord = try SenderKeyRecord(bytes: data)
				senderKeyMap[SenderKeyName(sender: sender, distributionId: distributionId)] = senderKeyRecord
				return senderKeyRecord
			} else {
				return nil
			}
		}
	}
	
	public func getSenderDistributionID(senderID: String, groupId: Int64, isCreateNew: Bool) -> UUID? {
		let key = "\(groupId).\(senderID)"
		if let existingId = senderUuidMap[key] {
			return existingId
		} else {
			if isCreateNew {
				let uuidString = "\(groupId)" + senderID.dropFirst(String(groupId).count)
				let uuid = UUID(uuidString: uuidString)
				senderUuidMap[key] = uuid
				return uuid
			} else {
				return nil
			}
		}
	}
	
	public func saveSenderDistributionID(senderID: String, groupId: Int64) {
		_ = getSenderDistributionID(senderID: senderID, groupId: groupId, isCreateNew: true)
	}
	
	public func removeSenderKey(domain: String) {
		senderUuidMap.removeAll()
		senderKeyMap.removeAll()
		storage.removeAllObjects(collection: .domain(domain))
	}
}
