//
//  GroupDetailInteractor.swift
//  ClearKeep
//
//  Created by MinhDev on 28/03/2022.
//

import Common

protocol IGroupDetailInteractor {
	var worker: IGroupDetailWorker { get }
}

struct GroupDetailInteractor {
	let appState: Store<AppState>
}

extension GroupDetailInteractor: IGroupDetailInteractor {
	var worker: IGroupDetailWorker {
		let remoteStore = GroupDetailRemoteStore()
		let inMemoryStore = GroupDetailInMemoryStore()
		return GroupDetailWorker(remoteStore: remoteStore, inMemoryStore: inMemoryStore)
	}
}
