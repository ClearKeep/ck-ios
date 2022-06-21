//
//  ChatGroupInteractor.swift
//  ClearKeep
//
//  Created by đông on 04/04/2022.
//

import Common
import ChatSecure
import Model

protocol IChatGroupInteractor {
	var worker: IChatGroupWorker { get }
	
	func createGroup(by clientId: String, groupName: String, groupType: String, lstClient: [CreatGroupGetUsersViewModel]) async -> (Result<CreatGroupViewModels, Error>)
	func searchUser(keyword: String) async -> Loadable<CreatGroupViewModels>
	func getProfile() async -> Loadable<CreatGroupViewModels>
}

struct ChatGroupInteractor {
	let appState: Store<AppState>
	let channelStorage: IChannelStorage
	let groupService: IGroupService
	let userService: IUserService
}

extension ChatGroupInteractor: IChatGroupInteractor {
	
	var worker: IChatGroupWorker {
		let remoteStore = ChatGroupRemoteStore(groupService: groupService, userService: userService)
		let inMemoryStore = ChatGroupInMemoryStore()
		return ChatGroupWorker(channelStorage: channelStorage, remoteStore: remoteStore, inMemoryStore: inMemoryStore)
	}
	
	func createGroup(by clientId: String, groupName: String, groupType: String, lstClient: [CreatGroupGetUsersViewModel]) async -> (Result<CreatGroupViewModels, Error>) {
		let result = await worker.createGroup(by: clientId, groupName: groupName, groupType: groupType, lstClient: lstClient)
		
		switch result {
		case .success(let createGroup):
			return .success(CreatGroupViewModels(groups: createGroup))
		case .failure(let error):
			return .failure(error)
		}
	}
	
	func searchUser(keyword: String) async -> Loadable<CreatGroupViewModels> {
		let result = await worker.searchUser(keyword: keyword)
		
		switch result {
		case .success(let searchUser):
			return .loaded(CreatGroupViewModels(users: searchUser))
		case .failure(let error):
			return .failed(error)
		}
	}
	
	func getProfile() async -> Loadable<CreatGroupViewModels> {
		let result = await worker.getProfile()
		
		switch result {
		case .success(let user):
			return .loaded(CreatGroupViewModels(profile: user))
		case .failure(let error):
			return .failed(error)
		}
	}
}

struct StubChatGroupInteractor: IChatGroupInteractor {
	
	let channelStorage: IChannelStorage
	let groupService: IGroupService
	let userService: IUserService
	
	var worker: IChatGroupWorker {
		let remoteStore = ChatGroupRemoteStore(groupService: groupService, userService: userService)
		let inMemoryStore = ChatGroupInMemoryStore()
		return ChatGroupWorker(channelStorage: channelStorage, remoteStore: remoteStore, inMemoryStore: inMemoryStore)
	}
	
	func createGroup(by clientId: String, groupName: String, groupType: String, lstClient: [CreatGroupGetUsersViewModel]) async -> (Result<CreatGroupViewModels, Error>) {
		let result = await worker.createGroup(by: clientId, groupName: groupName, groupType: groupType, lstClient: lstClient)
		switch result {
		case .success(let createGroup):
			return .success(CreatGroupViewModels(groups: createGroup))
		case .failure(let error):
			return .failure(error)
		}
	}
	
	func searchUser(keyword: String) async -> Loadable<CreatGroupViewModels> {
		return .notRequested
	}
	
	func getProfile() async -> Loadable<CreatGroupViewModels> {
		return.notRequested
	}
}
