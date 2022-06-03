//
//  HomeInteractor.swift
//  iOSBase-SwiftUI
//
//  Created by NamNH on 15/02/2022.
//

import Common
import ChatSecure
import Model

protocol IHomeInteractor {
	var worker: IHomeWorker { get }
	
	func validateDomain(_ domain: String) -> Bool
	func getServers() -> [ServerViewModel]
	func getJoinedGroup() async -> Loadable<HomeViewModels>
	func didSelectServer(_ domain: String?) -> [ServerViewModel]
	func getProfile() async -> Loadable<HomeViewModels>
	func signOut() async
}

struct HomeInteractor {
	let appState: Store<AppState>
	let channelStorage: IChannelStorage
	let authenticationService: IAuthenticationService
	let groupService: IGroupService
	let userService: IUserService
}

extension HomeInteractor: IHomeInteractor {
	var worker: IHomeWorker {
		let remoteStore = HomeRemoteStore(authenticationService: authenticationService, groupService: groupService, userService: userService)
		let inMemoryStore = HomeInMemoryStore()
		return HomeWorker(channelStorage: channelStorage, remoteStore: remoteStore, inMemoryStore: inMemoryStore)
	}
	
	func validateDomain(_ domain: String) -> Bool {
		return worker.validateDomain(domain)
	}
	
	func getServers() -> [ServerViewModel] {
		return worker.servers.compactMap { ServerViewModel($0) }
	}
	
	func getJoinedGroup() async -> Loadable<HomeViewModels> {
		let result = await worker.getJoinedGroup()
		
		switch result {
		case .success(let groups):
			return .loaded(HomeViewModels(responseGroup: groups))
		case .failure(let error):
			return .failed(error)
		}
	}
	
	func didSelectServer(_ domain: String?) -> [ServerViewModel] {
		return worker.didSelectServer(domain).compactMap { ServerViewModel($0) }
	}
	
	func getProfile() async -> Loadable<HomeViewModels> {
		let result = await worker.getProfile()
		
		switch result {
		case .success(let user):
			return .loaded(HomeViewModels(responseUser: user))
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
	let userService: IUserService
	
	var worker: IHomeWorker {
		let remoteStore = HomeRemoteStore(authenticationService: authenticationService, groupService: groupService, userService: userService)
		let inMemoryStore = HomeInMemoryStore()
		return HomeWorker(channelStorage: channelStorage, remoteStore: remoteStore, inMemoryStore: inMemoryStore)
	}
	
	func validateDomain(_ domain: String) -> Bool {
		return true
	}
	
	func getServers() -> [ServerViewModel] {
		return []
	}
	
	func getJoinedGroup() async -> Loadable<HomeViewModels> {
		return .notRequested
	}
	
	func didSelectServer(_ domain: String?) -> [ServerViewModel] {
		return []
	}
	
	func getProfile() async -> Loadable<HomeViewModels> {
		return .notRequested
	}
	func signOut() async {
		//		let result = await worker.signOut()
	}
}
