//
//  ProfileModel.swift
//  ClearKeep
//
//  Created by MinhDev on 29/06/2022.
//

import Model
import ChatSecure
import Networking

struct ProfieModel: IUser {
	var id: String
	var displayName: String
	var email: String
	var phoneNumber: String
	var avatar: String
}

extension ProfieModel {
	init(profile: User_UserProfileResponse) {
		self.init(id: profile.id,
				  displayName: profile.displayName,
				  email: profile.email,
				  phoneNumber: profile.phoneNumber,
				  avatar: profile.avatar)
	}
}
