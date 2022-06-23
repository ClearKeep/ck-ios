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
}

struct CreatePeerViewModels {
	var searchUser: [CreatePeerUserViewModel]?
	var creatGroup: CreatePeerChatViewModel?
}

extension CreatePeerViewModels {
	init(users: ICreatePeerModels) {
		let searchUsers = users.searchUserModel?.lstUser.map { member in
			CreatePeerUserViewModel(member)
		}
		self.init(searchUser: searchUsers)
	}

	init(groups: ICreatePeerModels) {
		let creatGroups = groups.creatGroupModel.map { member in
			CreatePeerChatViewModel(member)
		}
		self.init(creatGroup: creatGroups)
	}
}
