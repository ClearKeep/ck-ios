//
//  UserViewModel.swift
//  ClearKeep
//
//  Created by MinhDev on 02/06/2022.
//

import Foundation
import Model

protocol IUserViewModels {
	var viewModelUser: IUser? { get }
}

struct UserViewModels: IUserViewModels {
	var viewModelUser: IUser?
	init(_ model: IHomeModels) {
		self.viewModelUser = model.userModel
	}
}

struct UserViewModel: Identifiable {
	var id: String
	var displayName: String
	var email: String
	var phoneNumber: String
	var avatar: String

	init(_ user: IUser?) {
		id = user?.id ?? ""
		displayName = user?.displayName ?? ""
		email = user?.email ?? ""
		phoneNumber = user?.phoneNumber ?? ""
		avatar = user?.avatar ?? ""
	}
}
