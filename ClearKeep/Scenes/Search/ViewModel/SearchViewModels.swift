//
//  SearchViewModels.swift
//  ClearKeep
//
//  Created by MinhDev on 26/07/2022.
//
import Foundation
import Networking
import ChatSecure
import Model

protocol ISearchViewModels {
	var groupViewModel: ISearchGroupViewModels? { get }
	var userViewModel: ISearchUserViewModels? { get }
	var searchUser: [SearchUserServerViewModel]? { get }
	var creatGroup: CreatePeerChatViewModel? { get }
}

struct SearchViewModels: ISearchViewModels {
	var groupViewModel: ISearchGroupViewModels?
	var userViewModel: ISearchUserViewModels?
	var searchUser: [SearchUserServerViewModel]?
	var creatGroup: CreatePeerChatViewModel?
}

extension SearchViewModels {
	
	init(responseGroup: ISearchModels, responseUser: ISearchModels, users: ISearchModels) {
		let searchUsers = users.searchUserModel?.lstUser.map { member in
			SearchUserServerViewModel(member)
		}
		self.groupViewModel = SearchGroupViewModels(model: responseGroup, responseUser: responseUser)
		self.userViewModel = SearchUserViewModels(responseUser)
		self.searchUser = searchUsers
	}
	
	init(groups: ISearchModels) {
		let creatGroups = groups.creatGroupModel.map { member in
			CreatePeerChatViewModel(member)
		}
		self.init(creatGroup: creatGroups)
	}
}
