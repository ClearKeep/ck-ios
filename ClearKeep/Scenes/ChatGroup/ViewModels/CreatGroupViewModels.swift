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
	var profileWithLink: CreatGroupGetUsersViewModel? { get }
	var searchUserWithEmail: [CreatGroupGetUsersViewModel]? { get }
}

struct CreatGroupViewModels: ICreatGroupViewModels {
	var searchUser: [CreatGroupGetUsersViewModel]?
	var creatGroup: CreatGroupViewModel?
	var getProfile: CreatGroupProfieViewModel?
	var clientInGroup: [CreatGroupGetUsersViewModel]?
	var profileWithLink: CreatGroupGetUsersViewModel?
	var searchUserWithEmail: [CreatGroupGetUsersViewModel]?
}

extension CreatGroupViewModels {
	
	init(users: IGroupChatModels, profile: IGroupChatModels) {
		var data = [CreatGroupGetUsersViewModel]()
		users.searchUserModel?.lstUser.forEach { member in
			profile.members?.forEach { item in
				if member.id == item.id {
					let user = CreatGroupGetUsersViewModel(searchUser: member, profile: item)
					data.append(user)
				}
			}
		}
		self.init(searchUser: data)
	}
	
	init(groups: IGroupChatModels) {
		let creatGroups = groups.creatGroupModel.map { member in
			CreatGroupViewModel(member)
		}
		self.creatGroup = creatGroups
	}
	
	init(clients: [IUserInfo]) {
		
		let getUser = clients.map { member in
			CreatGroupGetUsersViewModel(user: member)
		}
		self.init(clientInGroup: getUser)
	}
	
	init(searchUsers: [CreatGroupGetUsersViewModel]) {
		self.searchUser = searchUsers
	}
	
	init(profileInforWithLink: IGroupChatModels) {
		self.profileWithLink = CreatGroupGetUsersViewModel.init(user: profileInforWithLink.getProfileModelWithLink)
	}
	
	init(usersWithEmail: IGroupChatModels) {
		let searchUsers = usersWithEmail.searchUserModelWithEmail?.lstUser.map { member in
			CreatGroupGetUsersViewModel(user: member)
		}
		self.searchUserWithEmail = searchUsers
	}
}
