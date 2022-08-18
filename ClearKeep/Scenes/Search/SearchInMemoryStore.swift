//
//  SearchInMemoryStore.swift
//  ClearKeep
//
//  Created by MinhDev on 05/04/2022.
//

import Foundation
import ChatSecure
import RealmSwift

protocol ISearchInMemoryStore {
	func getMessageFromLocal(groupId: Int64, ownerDomain: String, ownerId: String) -> Results<RealmMessage>?
}

struct SearchInMemoryStore {
	let realmManager: RealmManager
}

extension SearchInMemoryStore: ISearchInMemoryStore {
	func getMessageFromLocal(groupId: Int64, ownerDomain: String, ownerId: String) -> Results<RealmMessage>? {
		return realmManager.getMessages(groupId: groupId, ownerDomain: ownerDomain, ownerId: ownerId)
	}
}
