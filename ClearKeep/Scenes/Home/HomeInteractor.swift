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
	func registerToken(_ token: Data)
	func subscribeAndListenServers()
	func getServers() -> [ServerViewModel]
	func getServerInfo() async -> Loadable<HomeViewModels>
	func didSelectServer(_ domain: String?) -> [ServerViewModel]
	func signOut() async
	func refreshToken() async -> Bool
}

struct HomeInteractor {
	let appState: Store<AppState>
	let channelStorage: IChannelStorage
	let authenticationService: IAuthenticationService
	let groupService: IGroupService
	let userService: IUserService
	let clientStore: ClientStore
}

extension HomeInteractor: IHomeInteractor {
	var worker: IHomeWorker {
		let remoteStore = HomeRemoteStore(authenticationService: authenticationService, groupService: groupService, userService: userService, clientStore: clientStore)
		let inMemoryStore = HomeInMemoryStore()
		return HomeWorker(channelStorage: channelStorage, remoteStore: remoteStore, inMemoryStore: inMemoryStore)
	}
	
	func validateDomain(_ domain: String) -> Bool {
		return worker.validateDomain(domain)
	}
	
	func registerToken(_ token: Data) {
		worker.registerToken(token)
	}
	
	func subscribeAndListenServers() {
		worker.subscribeAndListenServers()
	}
	
	func getServers() -> [ServerViewModel] {
		return worker.servers.compactMap { ServerViewModel($0) }
	}
	
	func getServerInfo() async -> Loadable<HomeViewModels> {
		let result = await worker.getJoinedGroup()
		
		switch result {
		case .success(let groups):
			let result = await worker.getProfile()
			
			switch result {
			case .success(let user):
				return .loaded(HomeViewModels(responseGroup: groups, responseUser: user))
			case .failure(let error):
				return .failed(error)
			}
		case .failure(let error):
			return .failed(error)
		}
	}
	
	func didSelectServer(_ domain: String?) -> [ServerViewModel] {
		return worker.didSelectServer(domain).compactMap { ServerViewModel($0) }
	}
	
	func signOut() async {
		let result = await worker.signOut()
		if result {
			print("logout success")
		} else {
			print("logout fail")
		}
	}
	
	func refreshToken() async -> Bool {
		let result = await worker.refreshToken()
		return result
	}
}

struct StubHomeInteractor: IHomeInteractor {
	let channelStorage: IChannelStorage
	let authenticationService: IAuthenticationService
	let groupService: IGroupService
	let userService: IUserService
	let clientStore: ClientStore
	
	var worker: IHomeWorker {
		let remoteStore = HomeRemoteStore(authenticationService: authenticationService, groupService: groupService, userService: userService, clientStore: clientStore)
		let inMemoryStore = HomeInMemoryStore()
		return HomeWorker(channelStorage: channelStorage, remoteStore: remoteStore, inMemoryStore: inMemoryStore)
	}
	
	func validateDomain(_ domain: String) -> Bool {
		return true
	}
	
	func registerToken(_ token: Data) {
		worker.registerToken(token)
	}
	
	func subscribeAndListenServers() {
		worker.subscribeAndListenServers()
	}
	
	func getServers() -> [ServerViewModel] {
		return []
	}
	
	func getServerInfo() async -> Loadable<HomeViewModels> {
		return .notRequested
	}
	
	func didSelectServer(_ domain: String?) -> [ServerViewModel] {
		return []
	}
	
	func signOut() async {
		//		let result = await worker.signOut()
	}
	
	func refreshToken() async -> Bool {
		return true
	}
}
