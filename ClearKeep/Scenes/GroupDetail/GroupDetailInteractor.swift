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

	func getClientInGroup(by groupId: Int64) async -> Loadable<IGroupDetailViewModels>
	func searchUser(keyword: String, groupId: Int64) async -> Loadable<IGroupDetailViewModels>
	func addMember(_ user: GroupDetailUserViewModels, groupId: Int64) async -> Loadable<IGroupDetailViewModels>
	func getUserInfor(clientId: String, workSpace: String) async -> Loadable<IGroupDetailViewModels>
	func searchUserWithEmail(email: String) async -> Loadable<IGroupDetailViewModels>
	func checkPeopleLink(link: String) -> Bool
	func getPeopleFromLink(link: String) -> (id: String, userName: String, domain: String)?
	func lstMemberRemove(by groupId: Int64) async -> Loadable<IGroupDetailViewModels>
	func removeMember(_ user: GroupDetailClientViewModel, groupId: Int64) async -> (Result<IGroupDetailViewModels, Error>)
	func leaveGroup(_ user: GroupDetailClientViewModel, groupId: Int64) async -> Loadable<IGroupDetailViewModels>
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

	func searchUser(keyword: String, groupId: Int64) async -> Loadable<IGroupDetailViewModels> {
		let result = await worker.searchUser(keyword: keyword)

		switch result {
		case .success(let user):
			let result = await worker.getGroup(by: groupId)
			switch result {
			case .success(let group):
				let members = group.groupModel?.groupMembers.filter({ $0.userState == "active" }) ?? []
				let lstUserGroup = user.searchUser?.lstUser.map { lst in
					GroupDetailUserViewModels(user: lst)
				}.filter({ data in
					return !(members.contains(where: { user in
						user.userId == data.id
					}))
				})

				return .loaded(GroupDetailViewModels(users: lstUserGroup ?? []))
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
		case .success(let groups):

			var ids: [[String: String]] = []
			groups.groupModel?.groupMembers.filter { $0.userState == "active" }.forEach({ data in
				let idMembers = [["id": data.userId, "domain": data.domain]]
				ids.append(contentsOf: idMembers)
			})
			ids.append(["id": DependencyResolver.shared.channelStorage.currentServer?.profile?.userId ?? "",
						"domain": DependencyResolver.shared.channelStorage.currentDomain])
			let result = await worker.getListStatus(data: Array(Set(ids)))

			switch result {
			case .success(let user):
				return .loaded(GroupDetailViewModels(avatar: user, clients: groups))
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

	func lstMemberRemove(by groupId: Int64) async -> Loadable<IGroupDetailViewModels> {
		let result = await worker.getGroup(by: groupId)
		switch result {
		case .success(let getGroup):
			return .loaded(GroupDetailViewModels(members: getGroup))
		case .failure(let error):
			return .failed(error)
		}
	}

	func removeMember(_ user: GroupDetailClientViewModel, groupId: Int64) async -> (Result<IGroupDetailViewModels, Error>) {
		let result = await worker.leaveGroup(user, groupId: groupId)

		switch result {
		case .success(let user):
			return .success(GroupDetailViewModels(leaveGroup: user))
		case .failure(let error):
			return .failure(error)
		}
	}

	func leaveGroup(_ user: GroupDetailClientViewModel, groupId: Int64) async -> Loadable<IGroupDetailViewModels> {
		let result = await worker.leaveGroup(user, groupId: groupId)
		switch result {
		case .success(let member):
			return .loaded(GroupDetailViewModels(leaveGroup: member))
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

	func searchUser(keyword: String, groupId: Int64) async -> Loadable<IGroupDetailViewModels> {
		return .notRequested
	}

	func addMember(_ user: GroupDetailUserViewModels, groupId: Int64) async -> Loadable<IGroupDetailViewModels> {
		return .notRequested
	}

	func getClientInGroup(by groupId: Int64) async -> Loadable<IGroupDetailViewModels> {
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

	func lstMemberRemove(by groupId: Int64) async -> Loadable<IGroupDetailViewModels> {
		return .notRequested
	}

	func removeMember(_ user: GroupDetailClientViewModel, groupId: Int64) async -> (Result<IGroupDetailViewModels, Error>) {
		let result = await worker.leaveGroup(user, groupId: groupId)

		switch result {
		case .success(let users):
			return .success(GroupDetailViewModels(leaveGroup: users))
		case .failure(let error):
			return .failure(error)
		}
	}

	func leaveGroup(_ user: GroupDetailClientViewModel, groupId: Int64) async -> Loadable<IGroupDetailViewModels> {
		return .notRequested
	}
}
