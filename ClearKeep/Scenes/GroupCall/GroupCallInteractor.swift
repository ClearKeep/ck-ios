//
//  GroupCallInteractor.swift
//  ClearKeep
//
//  Created by đông on 07/04/2022.
//

import Common

protocol IGroupCallInteractor {
	var worker: IGroupCallWorker { get }
}

struct GroupCallInteractor {
	let appState: Store<AppState>
}

extension GroupCallInteractor: IGroupCallInteractor {
	var worker: IGroupCallWorker {
		let remoteStore = GroupCallRemoteStore()
		let inMemoryStore = GroupCallInMemoryStore()
		return GroupCallWorker(remoteStore: remoteStore, inMemoryStore: inMemoryStore)
	}
}
