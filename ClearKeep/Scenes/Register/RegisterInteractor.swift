//
//  RegisterInteractor.swift
//  ClearKeep
//
//  Created by MinhDev on 07/03/2022.
//

import Common

protocol IRegisterInteractor {
	var worker: IRegisterWorker { get }
}

struct RegisterInteractor {
	let appState: Store<AppState>
}

extension RegisterInteractor: IRegisterInteractor {
	var worker: IRegisterWorker {
		let remoteStore = RegisterRemoteStore()
		let inMemoryStore = RegisterInMemoryStore()
		return RegisterWorker(remoteStore: remoteStore, inMemoryStore: inMemoryStore)
	}
}
