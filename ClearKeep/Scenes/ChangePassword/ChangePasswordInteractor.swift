//
//  ChangePasswordInteractor.swift
//  ClearKeep
//
//  Created by MinhDev on 22/03/2022.
//

import Common

protocol IChangePasswordInteractor {
	var worker: IChangePasswordWorker { get }
}

struct ChangePasswordInteractor {
	let appState: Store<AppState>
}

extension ChangePasswordInteractor: IChangePasswordInteractor {
	var worker: IChangePasswordWorker {
		let remoteStore = ChangePasswordRemoteStore()
		let inMemoryStore = ChangePasswordInMemoryStore()
		return ChangePasswordWorker(remoteStore: remoteStore, inMemoryStore: inMemoryStore)
	}
}
