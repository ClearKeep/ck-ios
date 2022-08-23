//
//  HomeInteractor.swift
//  iOSBase-SwiftUI
//
//  Created by NamNH on 15/02/2022.
//

import Common
import ChatSecure
import Model
import CommonUI

protocol IHomeInteractor {
	var worker: IHomeWorker { get }
	
	func validateDomain(_ domain: String) -> Bool
	func registerToken(_ token: Data)
	func subscribeAndListenServers()
	func getServers() -> [ServerViewModel]
	func getServerInfo() async -> Loadable<HomeViewModels>
	@discardableResult
	func didSelectServer(_ domain: String?) -> [ServerViewModel]
	func signOut() async
	func updateStatus(status: String) async -> Loadable<UserViewModels>
	func getSenderName(fromClientId: String, groupID: Int64) -> String
	func getGroupName(groupID: Int64) -> String
	func removeServer()
	func workspaceInfo(workspaceDomain: String) async -> Loadable<Bool>
}

struct HomeInteractor {
	let appState: Store<AppState>
	let channelStorage: IChannelStorage
	let authenticationService: IAuthenticationService
	let groupService: IGroupService
	let userService: IUserService
	let workspaceService: IWorkspaceService
}

extension HomeInteractor: IHomeInteractor {
	var worker: IHomeWorker {
		let remoteStore = HomeRemoteStore(authenticationService: authenticationService, groupService: groupService, userService: userService, workspaceService: workspaceService)
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

	func removeServer() {
		worker.removeServer()
	}

	func getServerInfo() async -> Loadable<HomeViewModels> {
		let result = await worker.getJoinedGroup()
		await worker.pingRequest()
		
		switch result {
		case .success(let groups):
			var ids: [[String: String]] = []
		    groups.groupModel?.forEach({ data in
				let idMembers = data.groupMembers.map({ ["id": $0.userId, "domain": $0.domain] })
				ids.append(contentsOf: idMembers)
			})
			ids.append(["id": DependencyResolver.shared.channelStorage.currentServer?.profile?.userId ?? "",
						"domain": DependencyResolver.shared.channelStorage.currentDomain])
			let result = await worker.getListStatus(data: Array(Set(ids)))

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
	
	func updateStatus(status: String) async -> Loadable<UserViewModels> {
		let result = await worker.updateStatus(status: status)
		switch result {
		case .success:
			let result = await worker.getListStatus(data: [["id": DependencyResolver.shared.channelStorage.currentServer?.profile?.userId ?? "",
														   "domain": DependencyResolver.shared.channelStorage.currentDomain]])
			switch result {
			case .success(let user):
				return .loaded(UserViewModels(user))
			case .failure(let error):
				return .failed(error)
			}
		case .failure(let error):
			return .failed(error)
		}
	}
	
	@discardableResult
	func didSelectServer(_ domain: String?) -> [ServerViewModel] {
		return worker.didSelectServer(domain).compactMap { ServerViewModel($0) }
	}
	
	func signOut() async {
		_ = await worker.signOut()
	}
	
	func getSenderName(fromClientId: String, groupID: Int64) -> String {
		guard let server = channelStorage.tempServer else { return "" }
		let name = channelStorage.getSenderName(fromClientId: fromClientId, groupId: groupID, domain: server.serverDomain, ownerId: server.ownerClientId)
		return name
	}
	
	func getGroupName(groupID: Int64) -> String {
		guard let server = channelStorage.tempServer else { return "" }
		let name = channelStorage.getGroupName(groupId: groupID, domain: server.serverDomain, ownerId: server.ownerClientId)
		return name
	}

	func workspaceInfo(workspaceDomain: String) async -> Loadable<Bool> {
		let result = await worker.workspaceInfo(workspaceDomain: workspaceDomain)

		switch result {
		case .success(let data):
			return .loaded(data)
		case .failure(let error):
			return .failed(error)
		}
	}
}

struct StubHomeInteractor: IHomeInteractor {
	let channelStorage: IChannelStorage
	let authenticationService: IAuthenticationService
	let groupService: IGroupService
	let userService: IUserService
	let workspaceService: IWorkspaceService
	
	var worker: IHomeWorker {
		let remoteStore = HomeRemoteStore(authenticationService: authenticationService, groupService: groupService, userService: userService, workspaceService: workspaceService)
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
		_ = await worker.signOut()
	}
	
	func updateStatus(status: String) async -> Loadable<UserViewModels> {
		return .notRequested
	}

	func removeServer() {
		worker.removeServer()
	}
	
	func getSenderName(fromClientId: String, groupID: Int64) -> String {
		return ""
	}
	
	func getGroupName(groupID: Int64) -> String {
		return ""
	}

	func workspaceInfo(workspaceDomain: String) async -> Loadable<Bool> {
		return .notRequested
	}
}
