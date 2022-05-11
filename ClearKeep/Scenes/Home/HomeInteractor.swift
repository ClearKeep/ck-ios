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
	
	func getJoinedGroup() async
	func signOut() async
}

struct HomeInteractor {
	let appState: Store<AppState>
	let channelStorage: IChannelStorage
	let authenticationService: IAuthenticationService
	let groupService: IGroupService
}

extension HomeInteractor: IHomeInteractor {
	var worker: IHomeWorker {
		let remoteStore = HomeRemoteStore(authenticationService: authenticationService, groupService: groupService)
		let inMemoryStore = HomeInMemoryStore()
		return HomeWorker(channelStorage: channelStorage, remoteStore: remoteStore, inMemoryStore: inMemoryStore)
	}
	
	func getJoinedGroup() async {
		let result = await worker.getJoinedGroup()
	}
	
	func signOut() async {
		let result = await worker.signOut()
	}
}

struct StubHomeInteractor: IHomeInteractor {
	let channelStorage: IChannelStorage
	let authenticationService: IAuthenticationService
	let groupService: IGroupService
	
	var worker: IHomeWorker {
		let remoteStore = HomeRemoteStore(authenticationService: authenticationService, groupService: groupService)
		let inMemoryStore = HomeInMemoryStore()
		return HomeWorker(channelStorage: channelStorage, remoteStore: remoteStore, inMemoryStore: inMemoryStore)
	}
	
	func getJoinedGroup() async {
		let result = await worker.getJoinedGroup()
	}
	
	func signOut() async {
		let result = await worker.signOut()
	}
}
