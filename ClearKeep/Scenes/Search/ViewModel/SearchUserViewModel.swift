//
//  SearchUserViewModel.swift
//  ClearKeep
//
//  Created by MinhDev on 26/07/2022.
//

import Foundation
import Model

protocol ISearchUserViewModels {
	var viewModelUser: IUser? { get }
}

struct SearchUserViewModels: ISearchUserViewModels {
	var viewModelUser: IUser?
	init(_ model: ISearchModels) {
		self.viewModelUser = model.userModel
	}
}

struct SearchUserViewModel: Identifiable {
	var id: String
	var displayName: String
	var email: String
	var phoneNumber: String
	var avatar: String
	var status: StatusType
	
	init(_ user: IUser?) {
		id = user?.id ?? ""
		displayName = user?.displayName ?? ""
		email = user?.email ?? ""
		phoneNumber = user?.phoneNumber ?? ""
		avatar = user?.avatar ?? ""
		status = StatusType(rawValue: user?.status ?? "") ?? .undefined
	}
}

struct SearchUserServerViewModel: Identifiable {
	var id: String
	var displayName: String
	var workspaceDomain: String
	
	init(_ user: IUserInfo?) {
		id = user?.id ?? ""
		displayName = user?.displayName ?? ""
		workspaceDomain = user?.workspaceDomain ?? ""
	}
	
	init(id: String, displayName: String, workspaceDomain: String) {
		self.id = id
		self.displayName = displayName
		self.workspaceDomain = workspaceDomain
	}
}
