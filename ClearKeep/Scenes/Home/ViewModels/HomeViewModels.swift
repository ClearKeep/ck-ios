//
//  HomeViewModels.swift
//  ClearKeep
//
//  Created by MinhDev on 03/06/2022.
//

import Foundation
import Networking
import ChatSecure
import Model

protocol IHomeViewModels {
	var groupViewModel: IGroupViewModels? { get }
	var userViewModel: IUserViewModels? { get }
}

struct HomeViewModels {
	var groupViewModel: IGroupViewModels?
	var userViewModel: IUserViewModels?
}

extension HomeViewModels {
	init(responseGroup: IHomeModels) {
		self.init(groupViewModel: GroupViewModels(responseGroup))
	}

	init(responseUser: IHomeModels) {
		self.init(userViewModel: UserViewModels(responseUser))
	}
}
