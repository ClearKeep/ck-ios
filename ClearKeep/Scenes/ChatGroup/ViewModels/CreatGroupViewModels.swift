//
//  CreatGroupViewModels.swift
//  ClearKeep
//
//  Created by MinhDev on 13/06/2022.
//

import Foundation
import Model

protocol ICreatGroupViewModels {
	var getUser: [CreatGroupGetUsersViewModel]? { get }
	var searchUser: [CreatGroupGetUsersViewModel]? { get }
	var creatGroup: CreatGroupViewModel? { get }
	var getProfile: ICreatGroupProfieViewModels? { get }
	var clientInGroup: [CreatGroupGetUsersViewModel]? { get }
}

struct CreatGroupViewModels {
	var getUser: [CreatGroupGetUsersViewModel]?
	var searchUser: [CreatGroupGetUsersViewModel]?
	var creatGroup: CreatGroupViewModel?
	var getProfiles: ICreatGroupProfieViewModels?
	var clientInGroup: [CreatGroupGetUsersViewModel]?
}

extension CreatGroupViewModels {
	init(getUsers: IGroupChatModels) {
		let getUser = getUsers.getUserModel?.lstUser.map { member in
			CreatGroupGetUsersViewModel(member)
		}
		self.init(getUser: getUser)
	}
	
	init(users: IGroupChatModels) {
		let searchUsers = users.searchUserModel?.lstUser.map { member in
			CreatGroupGetUsersViewModel(member)
		}
		self.init(searchUser: searchUsers)
	}
	
	init(groups: IGroupChatModels) {
		let creatGroups = groups.creatGroupModel.map { member in
			CreatGroupViewModel(member)
		}
		self.init(creatGroup: creatGroups)
	}

	init(profile: IGroupChatModels) {
		self.init(getProfiles: CreatGroupProfieViewModels(profile))
	}

	init(clients: [IUserInfoResponse]) {
		
		let getUser = clients.map { member in
			CreatGroupGetUsersViewModel(member)
		}
		self.init(clientInGroup: getUser)
	}
}
