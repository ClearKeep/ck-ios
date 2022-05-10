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
	
	func signOut()
}

struct HomeInteractor {
	let appState: Store<AppState>
	let channelStorage: IChannelStorage
	let authenticationService: IAuthenticationService
}

extension HomeInteractor: IHomeInteractor {
	var worker: IHomeWorker {
		let remoteStore = HomeRemoteStore(channelStorage: channelStorage, authenticationService: authenticationService)
		let inMemoryStore = HomeInMemoryStore()
		return HomeWorker(remoteStore: remoteStore, inMemoryStore: inMemoryStore)
	}
	
	func signOut() {
		worker.signOut()
	}
}

struct StubHomeInteractor: IHomeInteractor {
	let channelStorage: IChannelStorage
	let authenticationService: IAuthenticationService
	
	var worker: IHomeWorker {
		let remoteStore = HomeRemoteStore(channelStorage: channelStorage, authenticationService: authenticationService)
		let inMemoryStore = HomeInMemoryStore()
		return HomeWorker(remoteStore: remoteStore, inMemoryStore: inMemoryStore)
	}
	
	func signOut() {
		worker.signOut()
	}
}
