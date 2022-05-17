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
	
	func getServers() -> [ServerViewModel]
	func getJoinedGroup() async -> Loadable<[GroupViewModel]>
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
	
	func getServers() -> [ServerViewModel] {
		let serverViewModels = worker.servers.compactMap { ServerViewModel($0) }
		return serverViewModels
	}
	
	func getJoinedGroup() async -> Loadable<[GroupViewModel]> {
		let result = await worker.getJoinedGroup()
		
		switch result {
		case .success(let groups):
			let groupViewModels = groups.compactMap { GroupViewModel($0) }
			return .loaded(groupViewModels)
		case .failure(let error):
			return .failed(error)
		}
	}
	
	func signOut() async {
//		let result = await worker.signOut()
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
	
	func getServers() -> [ServerViewModel] {
		return []
	}
	
	func getJoinedGroup() async -> Loadable<[GroupViewModel]> {
		return .notRequested
	}
	
	func signOut() async {
//		let result = await worker.signOut()
	}
}
