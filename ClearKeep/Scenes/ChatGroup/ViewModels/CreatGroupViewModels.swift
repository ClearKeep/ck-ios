//
//  CreatGroupViewModels.swift
//  ClearKeep
//
//  Created by MinhDev on 13/06/2022.
//

import Foundation
import Model

protocol ICreatGroupViewModels {
	var searchUser: [CreatGroupGetUsersViewModel]? { get }
	var creatGroup: CreatGroupViewModel? { get }
	var getProfile: CreatGroupProfieViewModel? { get }
	var clientInGroup: [CreatGroupGetUsersViewModel]? { get }
}

struct CreatGroupViewModels {
	var searchUser: [CreatGroupGetUsersViewModel]?
	var creatGroup: CreatGroupViewModel?
	var getProfiles: CreatGroupProfieViewModel?
	var clientInGroup: [CreatGroupGetUsersViewModel]?
}

extension CreatGroupViewModels {

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
		let myprofile = profile.getProfileModel
		self.init(getProfiles: CreatGroupProfieViewModel(myprofile))
	}

	init(clients: [IUserInfoResponse]) {
		
		let getUser = clients.map { member in
			CreatGroupGetUsersViewModel(member)
		}
		self.init(clientInGroup: getUser)
	}
}
