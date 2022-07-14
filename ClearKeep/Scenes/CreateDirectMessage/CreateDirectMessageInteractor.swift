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
	func searchUser(keyword: String) async -> Loadable<ICreatePeerViewModels>
	func createGroup(by clientId: String, groupName: String, groupType: String, lstClient: [CreatePeerUserViewModel]) async -> Loadable<ICreatePeerViewModels>
	func checkPeopleLink(link: String) -> Bool
	func getPeopleFromLink(link: String) -> (id: String, userName: String, domain: String)?
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

	func searchUser(keyword: String) async -> Loadable<ICreatePeerViewModels> {
		if keyword.removeCharacters(characterSet: .whitespacesAndNewlines).isEmpty {
			return .loaded(CreatePeerViewModels(groups: []))
		}
		
		let result = await worker.searchUser(keyword: keyword)
		switch result {
		case .success(let searchUser):
			let result = await worker.getProfile()

			switch result {
			case .success(let user):
				return .loaded(CreatePeerViewModels(users: searchUser, profile: user))
			case .failure(let error):
				return .failed(error)
			}
		case .failure(let error):
			return .failed(error)
		}
	}

	func createGroup(by clientId: String, groupName: String, groupType: String, lstClient: [CreatePeerUserViewModel]) async -> Loadable<ICreatePeerViewModels> {
		let result = await worker.createGroup(by: clientId, groupName: groupName, groupType: groupType, lstClient: lstClient)

		switch result {
		case .success(let createGroup):
			return .loaded(CreatePeerViewModels(groups: createGroup))
		case .failure(let error):
			return .failed(error)
		}
	}
	
	func getPeopleFromLink(link: String) -> (id: String, userName: String, domain: String)? {
		self.worker.getPeopleFromLink(link: link)
	}
	
	func checkPeopleLink(link: String) -> Bool {
		self.worker.checkPeopleLink(link: link)
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

	func searchUser(keyword: String) async -> Loadable<ICreatePeerViewModels> {
		return .notRequested
	}

	func createGroup(by clientId: String, groupName: String, groupType: String, lstClient: [CreatePeerUserViewModel]) async -> Loadable<ICreatePeerViewModels> {
		return .notRequested
	}
	
	func checkPeopleLink(link: String) -> Bool {
		false
	}
	
	func getPeopleFromLink(link: String) -> (id: String, userName: String, domain: String)? {
		nil
	}
}
