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
	
	func createGroup(by clientId: String, groupName: String, groupType: String, lstClient: [CreatGroupGetUsersViewModel]) async -> Loadable<ICreatGroupViewModels>
	func searchUser(keyword: String) async -> Loadable<ICreatGroupViewModels>
	func getUserInfor(clientId: String, workSpace: String) async -> Loadable<ICreatGroupViewModels>
	func searchUserWithEmail(email: String) async -> Loadable<ICreatGroupViewModels>
	func checkPeopleLink(link: String) -> Bool
	func getPeopleFromLink(link: String) -> (id: String, userName: String, domain: String)?
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
	
	func createGroup(by clientId: String, groupName: String, groupType: String, lstClient: [CreatGroupGetUsersViewModel]) async -> Loadable<ICreatGroupViewModels> {
		let result = await worker.createGroup(by: clientId, groupName: groupName, groupType: groupType, lstClient: lstClient)
		
		switch result {
		case .success(let createGroup):
			return .loaded(CreatGroupViewModels(groups: createGroup))
		case .failure(let error):
			return .failed(error)
		}
	}
	
	func searchUser(keyword: String) async -> Loadable<ICreatGroupViewModels> {
		let result = await worker.searchUser(keyword: keyword)
		
		switch result {
		case .success(let searchUser):
			let result = await worker.getProfile()

			switch result {
			case .success(let user):
				return .loaded(CreatGroupViewModels(users: searchUser, profile: user))
			case .failure(let error):
				return .failed(error)
			}
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
	
	func getUserInfor(clientId: String, workSpace: String) async -> Loadable<ICreatGroupViewModels> {
		let result = await worker.getUserInfor(clientId: clientId, workspaceDomain: workSpace)
		switch result {
		case .success(let createGroup):
			return .loaded(CreatGroupViewModels(profileInforWithLink: createGroup))
		case .failure(let error):
			return .failed(error)
		}
	}
	
	func searchUserWithEmail(email: String) async -> Loadable<ICreatGroupViewModels> {
		let result = await worker.searchUserWithEmail(email: email)
		switch result {
		case .success(let createGroup):
			return .loaded(CreatGroupViewModels(usersWithEmail: createGroup))
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
	
	func createGroup(by clientId: String, groupName: String, groupType: String, lstClient: [CreatGroupGetUsersViewModel]) async -> Loadable<ICreatGroupViewModels> {
		return .notRequested
	}
	
	func searchUser(keyword: String) async -> Loadable<ICreatGroupViewModels> {
		return .notRequested
	}
	
	func getUserInfor(clientId: String, workSpace: String) async -> Loadable<ICreatGroupViewModels> {
		return .notRequested
	}
	
	func searchUserWithEmail(email: String) async -> Loadable<ICreatGroupViewModels> {
		return .notRequested
	}
	
	func checkPeopleLink(link: String) -> Bool {
		self.worker.checkPeopleLink(link: link)
	}
	
	func getPeopleFromLink(link: String) -> (id: String, userName: String, domain: String)? {
		self.worker.getPeopleFromLink(link: link)
	}
}
