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
}

struct GroupDetailInteractor {
	let appState: Store<AppState>
	let groupService: IGroupService
	let channelStorage: IChannelStorage
}

extension GroupDetailInteractor: IGroupDetailInteractor {
	var worker: IGroupDetailWorker {
		let remoteStore = GroupDetailRemoteStore(groupService: groupService)
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

	func getClientInGroup(by groupId: Int64) async -> Loadable<IGroupDetailViewModels> {
		let result = await worker.getGroup(by: groupId)
		switch result {
		case .success(let getGroup):
			return .loaded(GroupDetailViewModels(clients: getGroup))
		case .failure(let error):
			return .failed(error)
		}
	}
}

struct StubGroupDetailInteractor: IGroupDetailInteractor {

	let groupService: IGroupService
	let channelStorage: IChannelStorage

	var worker: IGroupDetailWorker {
		let remoteStore = GroupDetailRemoteStore(groupService: groupService)
		let inMemoryStore = GroupDetailInMemoryStore()
		return GroupDetailWorker(channelStorage: channelStorage, remoteStore: remoteStore, inMemoryStore: inMemoryStore)
	}

	func getGroup(by groupId: Int64) async -> Loadable<IGroupDetailViewModels> {
		return .notRequested
	}

	func getClientInGroup(by groupId: Int64) async -> Loadable<IGroupDetailViewModels> {
		return .notRequested
	}
}
