//
//  CreatePeerViewModels.swift
//  ClearKeep
//
//  Created by MinhDev on 17/06/2022.
//

import SwiftUI
import Model

protocol ICreatePeerViewModels {
	var searchUser: [CreatePeerUserViewModel]? { get }
	var creatGroup: CreatePeerChatViewModel? { get }
	var getProfile: CreatePeerProfileViewModel? { get }
	var profileWithLink: CreatePeerUserViewModel? { get }
	var searchUserWithEmail: CreatePeerUserViewModel? { get }
}

struct CreatePeerViewModels: ICreatePeerViewModels {
	var searchUser: [CreatePeerUserViewModel]?
	var creatGroup: CreatePeerChatViewModel?
	var getProfile: CreatePeerProfileViewModel?
	var profileWithLink: CreatePeerUserViewModel?
	var searchUserWithEmail: CreatePeerUserViewModel?
}

extension CreatePeerViewModels {
	init(users: ICreatePeerModels, profile: ICreatePeerModels) {
		let searchUsers = users.searchUserModel?.lstUser.map { member in
			CreatePeerUserViewModel(member)
		}
		let myprofile = profile.getProfileModel.map { member in
			CreatePeerProfileViewModel(member)
		}
		self.searchUser = searchUsers
		self.getProfile = myprofile
	}

	init(groups: ICreatePeerModels) {
		let creatGroups = groups.creatGroupModel.map { member in
			CreatePeerChatViewModel(member)
		}
		self.init(creatGroup: creatGroups)
	}
	
	init(groups: [CreatePeerUserViewModel]?) {
		self.searchUser = groups
	}
	
	init(profileInforWithLink: ICreatePeerModels) {
		self.profileWithLink = CreatePeerUserViewModel.init(profileInforWithLink.getProfileModelWithLink)
	}
	
	init(usersWithEmail: ICreatePeerModels) {
		self.searchUserWithEmail = CreatePeerUserViewModel.init(usersWithEmail.searchUserModelWithEmail)
	}
}
