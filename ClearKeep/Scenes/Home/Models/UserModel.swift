//
//  UserModel.swift
//  ClearKeep
//
//  Created by MinhDev on 02/06/2022.
//

import Model
import ChatSecure
import Networking

struct UserModel: IUser {
	var id: String
	var displayName: String
	var email: String
	var phoneNumber: String
	var avatar: String
}

extension UserModel {
		init(response: User_UserProfileResponse) {
			self.init(id: response.id,
					  displayName: response.displayName,
					  email: response.email,
					  phoneNumber: response.phoneNumber,
					  avatar: response.avatar)
		}
}
