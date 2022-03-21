//
//  LoginInteractor.swift
//  ClearKeep
//
//  Created by đông on 07/03/2022.
//

import Common

protocol ILoginInteractor {
	var worker: ILoginWorker { get }
}

struct LoginInteractor {
	let appState: Store<AppState>
	let sampleAPIService: IAPIService
}

extension LoginInteractor: ILoginInteractor {
	var worker: ILoginWorker {
		let remoteStore = LoginRemoteStore(sampleAPIService: sampleAPIService)
		let inMemoryStore = LoginInMemoryStore()
		return LoginWorker(remoteStore: remoteStore, inMemoryStore: inMemoryStore)
	}
}

struct StubLoginInteractor: ILoginInteractor {
	let sampleAPIService: IAPIService

	var worker: ILoginWorker {
		let remoteStore = LoginRemoteStore(sampleAPIService: sampleAPIService)
		let inMemoryStore = LoginInMemoryStore()
		return LoginWorker(remoteStore: remoteStore, inMemoryStore: inMemoryStore)
	}
}
