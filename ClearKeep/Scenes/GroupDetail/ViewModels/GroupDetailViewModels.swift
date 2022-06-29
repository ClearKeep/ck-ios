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
	var groupBase: GroupDetailBaseViewModel? { get }
	var getProfile: GroupDetailUserViewModels? { get }
}

struct GroupDetailViewModels: IGroupDetailViewModels {
	var getGroup: GroupDetailViewModel?
	var getClientInGroup: [GroupDetailClientViewModel]?
	var searchUser: [GroupDetailUserViewModels]?
	var groupBase: GroupDetailBaseViewModel?
	var getProfile: GroupDetailUserViewModels?
}

extension GroupDetailViewModels {

	init(groups: IGroupDetailModels) {
		let group = groups.groupModel.map { member in
			GroupDetailViewModel(member)
		}
		self.init(getGroup: group)
	}

	init(clients: IGroupDetailModels) {
		let client = clients.groupModel?.groupMembers.map { member in
			GroupDetailClientViewModel(member)
		}
		self.init(getClientInGroup: client)
	}

	init(users: IGroupDetailModels) {
		let searchUsers = users.searchUser?.lstUser.map { member in
			GroupDetailUserViewModels(user: member)
		}
		self.init(searchUser: searchUsers)
	}

	init(error: IGroupDetailModels) {
		let errorGroup = error.groupBase.map { errors in
			GroupDetailBaseViewModel(errors)
		}
		self.init(groupBase: errorGroup)
	}

	init(profile: IGroupDetailModels) {
		let user = profile.getProfile.map { member in
			GroupDetailUserViewModels(profile: member)
		}
		self.init(getProfile: user)
	}
}
