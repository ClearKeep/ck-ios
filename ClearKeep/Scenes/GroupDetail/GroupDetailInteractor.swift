//
//  GroupDetailInteractor.swift
//  ClearKeep
//
//  Created by MinhDev on 28/03/2022.
//

import Common
import ChatSecure
import Model

protocol IGroupDetailInteractor {
	var worker: IGroupDetailWorker { get }

	func getGroup(by groupId: Int64) async -> Loadable<IGroupDetailViewModels>
	func getClientInGroup(by groupId: Int64) async -> Loadable<IGroupDetailViewModels>
	func searchUser(keyword: String) async -> Loadable<IGroupDetailViewModels>
	func addMember(_ user: GroupDetailUserViewModels, groupId: Int64) async -> Loadable<IGroupDetailViewModels>
	func getProfile() async -> Loadable<IGroupDetailViewModels>
	func getUserInfor(clientId: String, workSpace: String) async -> Loadable<IGroupDetailViewModels>
	func searchUserWithEmail(email: String) async -> Loadable<IGroupDetailViewModels>
	func checkPeopleLink(link: String) -> Bool
	func getPeopleFromLink(link: String) -> (id: String, userName: String, domain: String)?
}

struct GroupDetailInteractor {
	let appState: Store<AppState>
	let groupService: IGroupService
	let userService: IUserService
	let channelStorage: IChannelStorage
}

extension GroupDetailInteractor: IGroupDetailInteractor {

	var worker: IGroupDetailWorker {
		let remoteStore = GroupDetailRemoteStore(groupService: groupService, userService: userService)
		let inMemoryStore = GroupDetailInMemoryStore()
		return GroupDetailWorker(channelStorage: channelStorage, remoteStore: remoteStore, inMemoryStore: inMemoryStore)
	}

	func getGroup(by groupId: Int64) async -> Loadable<IGroupDetailViewModels> {
		let result = await worker.getGroup(by: groupId)

		switch result {
		case .success(let getGroup):
			return .loaded(GroupDetailViewModels(groups: getGroup))
		case .failure(let error):
			return .failed(error)
		}
	}

	func searchUser(keyword: String) async -> Loadable<IGroupDetailViewModels> {
		let result = await worker.searchUser(keyword: keyword)

		switch result {
		case .success(let searchUser):
			return .loaded(GroupDetailViewModels(users: searchUser))
		case .failure(let error):
			return .failed(error)
		}
	}

	func addMember(_ user: GroupDetailUserViewModels, groupId: Int64) async -> Loadable<IGroupDetailViewModels> {
		let result = await worker.addMember(user, groupId: groupId)

		switch result {
		case .success(let errorBase):
			return .loaded(GroupDetailViewModels(error: errorBase))
		case .failure(let error):
			return .failed(error)
		}
	}

	func getClientInGroup(by groupId: Int64) async -> Loadable<IGroupDetailViewModels> {
		let result = await worker.getGroup(by: groupId)
		switch result {
		case .success(let getGroup):
			return .loaded(GroupDetailViewModels(clients: getGroup))
		case .failure(let error):
			return .failed(error)
		}
	}

	func getProfile() async -> Loadable<IGroupDetailViewModels> {
		let result = await worker.getProfile()

		switch result {
		case .success(let user):
			return .loaded(GroupDetailViewModels(myprofile: user))
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

	func getUserInfor(clientId: String, workSpace: String) async -> Loadable<IGroupDetailViewModels> {
		let result = await worker.getUserInfor(clientId: clientId, workspaceDomain: workSpace)
		switch result {
		case .success(let getUser):
			return .loaded(GroupDetailViewModels(profileInforWithLink: getUser))
		case .failure(let error):
			return .failed(error)
		}
	}

	func searchUserWithEmail(email: String) async -> Loadable<IGroupDetailViewModels> {
		let result = await worker.searchUserWithEmail(email: email)
		switch result {
		case .success(let searchEmail):
			return .loaded(GroupDetailViewModels(usersWithEmail: searchEmail))
		case .failure(let error):
			return .failed(error)
		}
	}
}

struct StubGroupDetailInteractor: IGroupDetailInteractor {

	let groupService: IGroupService
	let userService: IUserService
	let channelStorage: IChannelStorage

	var worker: IGroupDetailWorker {
		let remoteStore = GroupDetailRemoteStore(groupService: groupService, userService: userService)
		let inMemoryStore = GroupDetailInMemoryStore()
		return GroupDetailWorker(channelStorage: channelStorage, remoteStore: remoteStore, inMemoryStore: inMemoryStore)
	}

	func getGroup(by groupId: Int64) async -> Loadable<IGroupDetailViewModels> {
		return .notRequested
	}

	func searchUser(keyword: String) async -> Loadable<IGroupDetailViewModels> {
		return .notRequested
	}

	func addMember(_ user: GroupDetailUserViewModels, groupId: Int64) async -> Loadable<IGroupDetailViewModels> {
		return .notRequested
	}

	func getClientInGroup(by groupId: Int64) async -> Loadable<IGroupDetailViewModels> {
		return .notRequested
	}

	func getProfile() async -> Loadable<IGroupDetailViewModels> {
		return .notRequested
	}

	func getUserInfor(clientId: String, workSpace: String) async -> Loadable<IGroupDetailViewModels> {
		return .notRequested
	}

	func searchUserWithEmail(email: String) async -> Loadable<IGroupDetailViewModels> {
		return .notRequested
	}

	func checkPeopleLink(link: String) -> Bool {
		self.worker.checkPeopleLink(link: link)
	}

	func getPeopleFromLink(link: String) -> (id: String, userName: String, domain: String)? {
		self.worker.getPeopleFromLink(link: link)
	}
}
