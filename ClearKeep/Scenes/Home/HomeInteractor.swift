//
//  HomeInteractor.swift
//  iOSBase-SwiftUI
//
//  Created by NamNH on 15/02/2022.
//

import Common

protocol IHomeInteractor {
	var worker: IHomeWorker { get }
}

struct HomeInteractor {
	let appState: Store<AppState>
	let sampleAPIService: IAPIService
}

extension HomeInteractor: IHomeInteractor {
	var worker: IHomeWorker {
		let remoteStore = HomeRemoteStore(sampleAPIService: sampleAPIService)
		let inMemoryStore = HomeInMemoryStore()
		return HomeWorker(remoteStore: remoteStore, inMemoryStore: inMemoryStore)
	}
}

struct StubHomeInteractor: IHomeInteractor {
	let sampleAPIService: IAPIService
	
	var worker: IHomeWorker {
		let remoteStore = HomeRemoteStore(sampleAPIService: sampleAPIService)
		let inMemoryStore = HomeInMemoryStore()
		return HomeWorker(remoteStore: remoteStore, inMemoryStore: inMemoryStore)
	}
}
