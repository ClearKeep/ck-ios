//
//  TwoFactorInteractor.swift
//  ClearKeep
//
//  Created by đông on 04/04/2022.
//

import Common

protocol ITwoFactorInteractor {
	var worker: ITwoFactorWorker { get }
}

struct TwoFactorInteractor {
	let appState: Store<AppState>
}

extension TwoFactorInteractor: ITwoFactorInteractor {
	var worker: ITwoFactorWorker {
		let remoteStore = TwoFactorRemoteStore()
		let inMemoryStore = TwoFactorInMemoryStore()
		return TwoFactorWorker(remoteStore: remoteStore, inMemoryStore: inMemoryStore)
	}
}
