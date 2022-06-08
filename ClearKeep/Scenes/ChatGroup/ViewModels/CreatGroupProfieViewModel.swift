//
//  CreatGroupProfieViewModel.swift
//  ClearKeep
//
//  Created by MinhDev on 14/06/2022.
//

import Foundation
import Model

protocol ICreatGroupProfieViewModels {
	var viewModelUser: IUser? { get }
}

struct CreatGroupProfieViewModels: ICreatGroupProfieViewModels {
	var viewModelUser: IUser?
	init(_ model: IGroupChatModels) {
		self.viewModelUser = model.getProfileModel
	}
}

struct CreatGroupProfieViewModel {
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
