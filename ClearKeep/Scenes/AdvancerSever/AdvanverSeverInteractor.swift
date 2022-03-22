//
//  AdvanverSeverInteractor.swift
//  ClearKeep
//
//  Created by MinhDev on 22/03/2022.
//

import Common

protocol IAdvanverSeverInteractor {
	var worker: IAdvanverSeverWorker { get }
}

struct AdvanverSeverInteractor {
	let appState: Store<AppState>
}

extension AdvanverSeverInteractor: IAdvanverSeverInteractor {
	var worker: IAdvanverSeverWorker {
		let remoteStore = AdvanverSeverRemoteStore()
		let inMemoryStore = AdvanverSeverInMemoryStore()
		return AdvanverSeverWorker(remoteStore: remoteStore, inMemoryStore: inMemoryStore)
	}
}
