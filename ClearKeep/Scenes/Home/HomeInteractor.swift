//
//  HomeInteractor.swift
//  iOSBase-SwiftUI
//
//  Created by NamNH on 15/02/2022.
//

import Common
import ChatSecure

protocol IHomeInteractor {
	var worker: IHomeWorker { get }
}

struct HomeInteractor {
	let appState: Store<AppState>
	let channelStorage: IChannelStorage
}

extension HomeInteractor: IHomeInteractor {
	var worker: IHomeWorker {
		let remoteStore = HomeRemoteStore(channelStorage: channelStorage)
		let inMemoryStore = HomeInMemoryStore()
		return HomeWorker(remoteStore: remoteStore, inMemoryStore: inMemoryStore)
	}
}

struct StubHomeInteractor: IHomeInteractor {
	let channelStorage: IChannelStorage
	
	var worker: IHomeWorker {
		let remoteStore = HomeRemoteStore(channelStorage: channelStorage)
		let inMemoryStore = HomeInMemoryStore()
		return HomeWorker(remoteStore: remoteStore, inMemoryStore: inMemoryStore)
	}
}
