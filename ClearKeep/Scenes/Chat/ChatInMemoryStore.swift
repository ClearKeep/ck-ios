//
//  ChatInMemoryStore.swift
//  ClearKeep
//
//  Created by Quang Pham on 22/04/2022.
//

import Foundation
import ChatSecure
import RealmSwift

protocol IChatInMemoryStore {
	func getJoinedGroupsFromLocal(ownerId: String, domain: String) async -> [RealmGroup]
	func getMessageFromLocal(groupId: Int64, ownerDomain: String, ownerId: String) -> Results<RealmMessage>?
	func saveDraftMessage(message: String, roomId: Int64, clientId: String, domain: String)
	func getDraftMessage(roomId: Int64, clientId: String, domain: String) -> String?
}

struct ChatInMemoryStore {
	let realmManager: RealmManager
	let clientStore: ClientStore
}

extension ChatInMemoryStore: IChatInMemoryStore {
	func getJoinedGroupsFromLocal(ownerId: String, domain: String) async -> [RealmGroup] {
		return realmManager.getJoinedGroup(ownerId: ownerId, domain: domain)
	}
	
	func getMessageFromLocal(groupId: Int64, ownerDomain: String, ownerId: String) -> Results<RealmMessage>? {
		return realmManager.getMessages(groupId: groupId, ownerDomain: ownerDomain, ownerId: ownerId)
	}
	
	func saveDraftMessage(message: String, roomId: Int64, clientId: String, domain: String) {
		clientStore.saveDraftMessage(message: message, roomId: roomId, clientId: clientId, domain: domain)
	}
	
	func getDraftMessage(roomId: Int64, clientId: String, domain: String) -> String? {
		return clientStore.getDraftMessage(roomId: roomId, clientId: clientId, domain: domain)
	}
}
