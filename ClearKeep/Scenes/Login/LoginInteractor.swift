//
//  LoginInteractor.swift
//  ClearKeep
//
//  Created by MinhDev on 07/03/2022.
//

import Common

protocol ILoginInteractor {
	var worker: ILoginWorker { get }
}

struct LoginInteractor {
	let appState: Store<AppState>
}

extension LoginInteractor: ILoginInteractor {
	var worker: ILoginWorker {
		let remoteStore = LoginRemoteStore()
		let inMemoryStore = LoginInMemoryStore()
		return LoginWorker(remoteStore: remoteStore, inMemoryStore: inMemoryStore)
	}
}
