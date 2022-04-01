//
//  CreateDirectMessageInteractor.swift
//  ClearKeep
//
//  Created by MinhDev on 01/04/2022.
//

import Common

protocol ICreateDirectMessageInteractor {
	var worker: ICreateDirectMessageWorker { get }
}

struct CreateDirectMessageInteractor {
	let appState: Store<AppState>
}

extension CreateDirectMessageInteractor: ICreateDirectMessageInteractor {
	var worker: ICreateDirectMessageWorker {
		let remoteStore = CreateDirectMessageRemoteStore()
		let inMemoryStore = CreateDirectMessageInMemoryStore()
		return CreateDirectMessageWorker(remoteStore: remoteStore, inMemoryStore: inMemoryStore)
	}
}
