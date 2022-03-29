//
//  DirectMessagesInteractor.swift
//  ClearKeep
//
//  Created by MinhDev on 29/03/2022.
//

import Common

protocol IDirectMessagesInteractor {
	var worker: IDirectMessagesWorker { get }
}

struct DirectMessagesInteractor {
	let appState: Store<AppState>
}

extension DirectMessagesInteractor: IDirectMessagesInteractor {
	var worker: IDirectMessagesWorker {
		let remoteStore = DirectMessagesRemoteStore()
		let inMemoryStore = DirectMessagesInMemoryStore()
		return DirectMessagesWorker(remoteStore: remoteStore, inMemoryStore: inMemoryStore)
	}
}
