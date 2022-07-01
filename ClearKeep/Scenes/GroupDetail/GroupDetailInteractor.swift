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
	func searchUser(keyword: String, groupId: Int64) async -> Loadable<IGroupDetailViewModels>
	func addMember(_ user: GroupDetailUserViewModels, groupId: Int64) async -> Loadable<IGroupDetailViewModels>
	func leaveGroup(_ user: GroupDetailClientViewModel, groupId: Int64) async -> Loadable<IGroupDetailViewModels>
	func getListMember(by groupId: Int64) async -> Loadable<IGroupDetailViewModels>
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
			let result = await worker.getProfile()

			switch result {
			case .success(let user):
				return .loaded(GroupDetailViewModels(groups: getGroup, profile: user))
			case .failure(let error):
				return .failed(error)
			}
		case .failure(let error):
			return .failed(error)
		}
	}

	func searchUser(keyword: String, groupId: Int64) async -> Loadable<IGroupDetailViewModels> {
		let result = await worker.searchUser(keyword: keyword)

		switch result {
		case .success(let searchUser):
			let result = await worker.getGroup(by: groupId)

			switch result {
			case .success(let group):
				return .loaded(GroupDetailViewModels(users: searchUser, groups: group))
			case .failure(let error):
				return .failed(error)
			}
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

	func leaveGroup(_ user: GroupDetailClientViewModel, groupId: Int64) async -> Loadable<IGroupDetailViewModels> {
		let result = await worker.leaveGroup(user, groupId: groupId)
		switch result {
		case .success(let errorBase):
			return .loaded(GroupDetailViewModels(removeClient: errorBase))
		case .failure(let error):
			return .failed(error)
		}
	}

	func getListMember(by groupId: Int64) async -> Loadable<IGroupDetailViewModels> {
		let result = await worker.getGroup(by: groupId)
		switch result {
		case .success(let getGroup):
			let result = await worker.getProfile()

			switch result {
			case .success(let user):
				return .loaded(GroupDetailViewModels(members: getGroup, profile: user))
			case .failure(let error):
				return .failed(error)
			}
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

	func searchUser(keyword: String, groupId: Int64) async -> Loadable<IGroupDetailViewModels> {
		return .notRequested
	}

	func addMember(_ user: GroupDetailUserViewModels, groupId: Int64) async -> Loadable<IGroupDetailViewModels> {
		return .notRequested
	}

	func getClientInGroup(by groupId: Int64) async -> Loadable<IGroupDetailViewModels> {
		return .notRequested
	}

	func leaveGroup(_ user: GroupDetailClientViewModel, groupId: Int64) async -> Loadable<IGroupDetailViewModels> {
		return .notRequested
	}
	
	func getListMember(by groupId: Int64) async -> Loadable<IGroupDetailViewModels> {
		return .notRequested
	}
}
