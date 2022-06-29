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

struct CreatGroupViewModels: ICreatGroupViewModels {
	var searchUser: [CreatGroupGetUsersViewModel]?
	var creatGroup: CreatGroupViewModel?
	var getProfile: CreatGroupProfieViewModel?
	var clientInGroup: [CreatGroupGetUsersViewModel]?
}

extension CreatGroupViewModels {
	
	init(users: IGroupChatModels, profile: IGroupChatModels) {
		let searchUsers = users.searchUserModel?.lstUser.map { member in
			CreatGroupGetUsersViewModel(member)
		}
		let myprofile = profile.getProfileModel
		self.searchUser = searchUsers
		self.getProfile = CreatGroupProfieViewModel(myprofile)
	}
	
	init(groups: IGroupChatModels) {
		let creatGroups = groups.creatGroupModel.map { member in
			CreatGroupViewModel(member)
		}
		self.creatGroup = creatGroups
	}
	
	init(clients: [IUserInfo]) {
		
		let getUser = clients.map { member in
			CreatGroupGetUsersViewModel(member)
		}
		self.init(clientInGroup: getUser)
	}
}
