//
//  UserProfileViewModel.swift
//  ClearKeep
//
//  Created by MinhDev on 08/06/2022.
//

import Foundation
import Model

struct UserProfileViewModel: Identifiable {
	var id: String
	var displayName: String
	var email: String
	var phoneNumber: String
	var avatar: String

	init(user: IUser?) {
		id = user?.id ?? ""
		displayName = user?.displayName ?? ""
		email = user?.email ?? ""
		phoneNumber = user?.phoneNumber ?? ""
		avatar = user?.avatar ?? ""
	}
}
