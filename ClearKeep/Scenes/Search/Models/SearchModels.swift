//
//  SearchModels.swift
//  ClearKeep
//
//  Created by MinhDev on 22/04/2022.
//

import UIKit
import SwiftUI
import Networking
import Model

protocol ISearchModels {
	var searchUsers: IGetUserResponse? { get }
	var searchGroups: SearchGroupModels? { get }
}

struct SearchModels {
	var searchUsers: IGetUserResponse?
	var searchGroups: SearchGroupModels?
}

extension SearchModels: ISearchModels {
	init(searchUser: User_SearchUserResponse) {
		self.init(searchUsers: UserResponseModel(searchUser: searchUser))
	}

	init(searchGroup: Group_SearchGroupsResponse) {
		self.init(searchGroups: SearchGroupModels(groupResponse: searchGroup))
	}
}
