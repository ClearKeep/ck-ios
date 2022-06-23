//
//  GroupDetailInteractor.swift
//  ClearKeep
//
//  Created by MinhDev on 28/03/2022.
//

import Common
import ChatSecure
import Model

protocol IGroupDetailInteractor {
	var worker: IGroupDetailWorker { get }
}

struct GroupDetailInteractor {
	let appState: Store<AppState>
	let groupService: IGroupService
}

extension GroupDetailInteractor: IGroupDetailInteractor {
	var worker: IGroupDetailWorker {
		let remoteStore = GroupDetailRemoteStore(groupService: groupService)
		let inMemoryStore = GroupDetailInMemoryStore()
		return GroupDetailWorker(remoteStore: remoteStore, inMemoryStore: inMemoryStore)
	}
}
