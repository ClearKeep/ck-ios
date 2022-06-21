//
//  ChatInMemoryStore.swift
//  ClearKeep
//
//  Created by Quang Pham on 22/04/2022.
//

import Foundation
import ChatSecure

protocol IChatInMemoryStore {
	func getJoinedGroupsFromLocal(ownerId: String, domain: String) async -> [RealmGroup]
}

struct ChatInMemoryStore {
	let realmManager: RealmManager
}

extension ChatInMemoryStore: IChatInMemoryStore {
	func getJoinedGroupsFromLocal(ownerId: String, domain: String) async -> [RealmGroup] {
		return realmManager.getJoinedGroup(ownerId: ownerId, domain: domain)
	}
}
