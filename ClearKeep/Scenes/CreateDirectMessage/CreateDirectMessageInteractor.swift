//
//  CreateDirectMessageInteractor.swift
//  ClearKeep
//
//  Created by MinhDev on 01/04/2022.
//

import Common
import ChatSecure
import Model

protocol ICreateDirectMessageInteractor {
	var worker: ICreateDirectMessageWorker { get }
	func searchUser(keyword: String) async -> Loadable<CreatePeerViewModels>
	func createGroup(by clientId: String, groupName: String, groupType: String, lstClient: [CreatePeerUserViewModel]) async -> Loadable<CreatePeerViewModels>
}

struct CreateDirectMessageInteractor {
	let appState: Store<AppState>
	let channelStorage: IChannelStorage
	let userService: IUserService
	let groupService: IGroupService
}

extension CreateDirectMessageInteractor: ICreateDirectMessageInteractor {
	var worker: ICreateDirectMessageWorker {
		let remoteStore = CreateDirectMessageRemoteStore(groupService: groupService, userService: userService)
		let inMemoryStore = CreateDirectMessageInMemoryStore()
		return CreateDirectMessageWorker(channelStorage: channelStorage, remoteStore: remoteStore, inMemoryStore: inMemoryStore)
	}

	func searchUser(keyword: String) async -> Loadable<CreatePeerViewModels> {
		let result = await worker.searchUser(keyword: keyword)

		switch result {
		case .success(let searchUser):
			return .loaded(CreatePeerViewModels(users: searchUser))
		case .failure(let error):
			return .failed(error)
		}
	}

	func createGroup(by clientId: String, groupName: String, groupType: String, lstClient: [CreatePeerUserViewModel]) async -> Loadable<CreatePeerViewModels> {
		let result = await worker.createGroup(by: clientId, groupName: groupName, groupType: groupType, lstClient: lstClient)

		switch result {
		case .success(let createGroup):
			return .loaded(CreatePeerViewModels(groups: createGroup))
		case .failure(let error):
			return .failed(error)
		}
	}
}

struct StubCreateDirectMessageInteractor: ICreateDirectMessageInteractor {
	let channelStorage: IChannelStorage
	let userService: IUserService
	let groupService: IGroupService

	var worker: ICreateDirectMessageWorker {
		let remoteStore = CreateDirectMessageRemoteStore(groupService: groupService, userService: userService)
		let inMemoryStore = CreateDirectMessageInMemoryStore()
		return CreateDirectMessageWorker(channelStorage: channelStorage, remoteStore: remoteStore, inMemoryStore: inMemoryStore)
	}

	func searchUser(keyword: String) async -> Loadable<CreatePeerViewModels> {
		return .notRequested
	}

	func createGroup(by clientId: String, groupName: String, groupType: String, lstClient: [CreatePeerUserViewModel]) async -> Loadable<CreatePeerViewModels> {
		return .notRequested
	}
}
