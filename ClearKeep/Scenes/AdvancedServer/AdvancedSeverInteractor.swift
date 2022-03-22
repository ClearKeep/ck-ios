//
//  AdvancedSeverInteractor.swift
//  ClearKeep
//
//  Created by MinhDev on 22/03/2022.
//

import Common

protocol IAdvancedSeverInteractor {
	var worker: IAdvancedSeverWorker { get }
}

struct AdvancedSeverInteractor {
	let appState: Store<AppState>
}

extension AdvancedSeverInteractor: IAdvancedSeverInteractor {
	var worker: IAdvancedSeverWorker {
		let remoteStore = AdvancedSeverRemoteStore()
		let inMemoryStore = AdvancedSeverInMemoryStore()
		return AdvancedSeverWorker(remoteStore: remoteStore, inMemoryStore: inMemoryStore)
	}
}
