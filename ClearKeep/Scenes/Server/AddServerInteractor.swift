//
//  AddServerInteractor.swift
//  ClearKeep
//
//  Created by MinhDev on 26/04/2022.
//

import Common

protocol IAddServerInteractor {
	var worker: IAddServerWorker { get }
}

struct AddServerInteractor {
	let appState: Store<AppState>
}

extension AddServerInteractor: IAddServerInteractor {
	var worker: IAddServerWorker {
		let remoteStore = AddServerRemoteStore()
		let inMemoryStore = AddServerInMemoryStore()
		return AddServerWorker(remoteStore: remoteStore, inMemoryStore: inMemoryStore)
	}
}
