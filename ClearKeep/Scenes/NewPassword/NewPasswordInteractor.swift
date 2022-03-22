//
//  NewPasswordInteractor.swift
//  ClearKeep
//
//  Created by MinhDev on 22/03/2022.
//

import Common

protocol INewPasswordInteractor {
	var worker: INewPasswordWorker { get }
}

struct NewPasswordInteractor {
	let appState: Store<AppState>
}

extension NewPasswordInteractor: INewPasswordInteractor {
	var worker: INewPasswordWorker {
		let remoteStore = NewPasswordRemoteStore()
		let inMemoryStore = NewPasswordInMemoryStore()
		return NewPasswordWorker(remoteStore: remoteStore, inMemoryStore: inMemoryStore)
	}
}
