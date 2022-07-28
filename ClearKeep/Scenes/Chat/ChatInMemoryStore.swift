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
}

struct ChatInMemoryStore {
	let realmManager: RealmManager
}

extension ChatInMemoryStore: IChatInMemoryStore {
	func getJoinedGroupsFromLocal(ownerId: String, domain: String) async -> [RealmGroup] {
		return realmManager.getJoinedGroup(ownerId: ownerId, domain: domain)
	}
	
	func getMessageFromLocal(groupId: Int64, ownerDomain: String, ownerId: String) -> Results<RealmMessage>? {
		return realmManager.getMessages(groupId: groupId, ownerDomain: ownerDomain, ownerId: ownerId)
	}
}
