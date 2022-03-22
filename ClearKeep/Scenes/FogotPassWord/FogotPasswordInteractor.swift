//
//  FogotPasswordInteractor.swift
//  ClearKeep
//
//  Created by MinhDev on 22/03/2022.
//

import Common

protocol IFogotPasswordInteractor {
	var worker: IFogotPasswordWorker { get }
}

struct FogotPasswordInteractor {
	let appState: Store<AppState>
}

extension FogotPasswordInteractor: IFogotPasswordInteractor {
	var worker: IFogotPasswordWorker {
		let remoteStore = FogotPasswordRemoteStore()
		let inMemoryStore = FogotPasswordInMemoryStore()
		return FogotPasswordWorker(remoteStore: remoteStore, inMemoryStore: inMemoryStore)
	}
}
