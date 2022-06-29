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
}

struct CreatePeerViewModels: ICreatePeerViewModels {
	var searchUser: [CreatePeerUserViewModel]?
	var creatGroup: CreatePeerChatViewModel?
	var getProfile: CreatePeerProfileViewModel?
}

extension CreatePeerViewModels {
	init(users: ICreatePeerModels, profile: ICreatePeerModels) {
		let searchUsers = users.searchUserModel?.lstUser.map { member in
			CreatePeerUserViewModel(member)
		}
		let myprofile = profile.getProfileModel
		self.searchUser = searchUsers
		self.getProfile = CreatePeerProfileViewModel(myprofile)
	}

	init(groups: ICreatePeerModels) {
		let creatGroups = groups.creatGroupModel.map { member in
			CreatePeerChatViewModel(member)
		}
		self.init(creatGroup: creatGroups)
	}
}
