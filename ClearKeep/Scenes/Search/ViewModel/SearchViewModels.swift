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
	var searchGroup: [SearchGroupViewModel]? { get }
	var searchUser: [SearchUserViewModel]? { get }

}

struct SearchViewModels: ISearchViewModels {
	var searchGroup: [SearchGroupViewModel]?
	var searchUser: [SearchUserViewModel]?
}

extension SearchViewModels {

	init(responseUser: ISearchModels, responseGroup: ISearchModels) {
		let lstUser = responseUser.searchUsers?.lstUser.map { member in
			SearchUserViewModel(member)
		}
		let lstGroup = responseGroup.searchGroups?.lstGroup?.compactMap { group in
			SearchGroupViewModel(group)
		}
		self.init(searchGroup: lstGroup, searchUser: lstUser)
	}

	init(responseUser: ISearchModels) {
		let lstUser = responseUser.searchUsers?.lstUser.map { member in
			SearchUserViewModel(member)
		}
		self.init(searchUser: lstUser)
	}

	init(responseGroup: ISearchModels) {
		let lstGroup = responseGroup.searchGroups?.lstGroup?.compactMap { group in
			SearchGroupViewModel(group)
		}
		self.init(searchGroup: lstGroup)
	}
}
