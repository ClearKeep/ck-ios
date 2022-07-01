//
//  GroupDetailViewModels.swift
//  ClearKeep
//
//  Created by MinhDev on 23/06/2022.
//
import Foundation
import Model

protocol IGroupDetailViewModels {
	var getGroup: GroupDetailViewModel? { get }
	var getClientInGroup: [GroupDetailClientViewModel]? { get }
	var searchUser: [GroupDetailUserViewModels]? { get }
	var searchClientInGroup: [GroupDetailClientViewModel]? { get }
	var groupBase: GroupDetailBaseViewModel? { get }
	var getProfile: GroupDetailUserViewModels? { get }
	var removeMember: [GroupDetailClientViewModel]? { get }
	var leaveGroup: GroupDetailBaseViewModel? { get }
}

struct GroupDetailViewModels: IGroupDetailViewModels {
	var getGroup: GroupDetailViewModel?
	var getClientInGroup: [GroupDetailClientViewModel]?
	var searchUser: [GroupDetailUserViewModels]?
	var searchClientInGroup: [GroupDetailClientViewModel]?
	var groupBase: GroupDetailBaseViewModel?
	var getProfile: GroupDetailUserViewModels?
	var removeMember: [GroupDetailClientViewModel]?
	var leaveGroup: GroupDetailBaseViewModel?
}

extension GroupDetailViewModels {

	init(groups: IGroupDetailModels, profile: IGroupDetailModels) {
		let group = groups.groupModel.map { member in
			GroupDetailViewModel(member)
		}
		let user = profile.getProfile.map { member in
			GroupDetailUserViewModels(profile: member)
		}
		self.getGroup = group
		self.getProfile = user
	}

	init(clients: IGroupDetailModels) {
		let client = clients.groupModel?.groupMembers.map { member in
			GroupDetailClientViewModel(member)
		}
		self.init(getClientInGroup: client)
	}

	init(users: IGroupDetailModels, groups: IGroupDetailModels) {
		let searchUsers = users.searchUser?.lstUser.map { member in
			GroupDetailUserViewModels(user: member)
		}
		let client = groups.groupModel?.groupMembers.map { member in
			GroupDetailClientViewModel(member)
		}
		self.searchUser = searchUsers
		self.searchClientInGroup = client
	}

	init(error: IGroupDetailModels) {
		let errorGroup = error.groupBase.map { errors in
			GroupDetailBaseViewModel(errors)
		}
		self.init(groupBase: errorGroup)
	}

	init(removeClient: IGroupDetailModels) {
		let errorGroup = removeClient.groupBase.map { errors in
			GroupDetailBaseViewModel(errors)
		}
		self.init(groupBase: errorGroup)
	}

	init(members: IGroupDetailModels, profile: IGroupDetailModels) {
		let client = members.groupModel?.groupMembers.map { member in
			GroupDetailClientViewModel(member)
		}
		let user = profile.getProfile.map { member in
			GroupDetailUserViewModels(profile: member)
		}
		self.removeMember = client
		self.getProfile = user
	}

	init(leaveMember: IGroupDetailModels) {
		let errorGroup = leaveMember.groupBase.map { errors in
			GroupDetailBaseViewModel(errors)
		}
		self.init(leaveGroup: errorGroup)
	}
}
