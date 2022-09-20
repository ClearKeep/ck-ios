//
//  Profile.swift
//  
//
//  Created by NamNH on 11/03/2022.
//

import UIKit
import Networking

protocol IProfile {
	var userId: String { get set }
	var userName: String? { get set }
	var email: String? { get set }
	var phoneNumber: String? { get set }
	var updatedAt: Int8 { get set }
	var avatar: String? { get set }
}

struct Profile: IProfile {
	var userId: String
	var userName: String?
	var email: String?
	var phoneNumber: String?
	var updatedAt: Int8
	var avatar: String?
}

extension Profile {
	init(profileResponse: User_UserProfileResponse) {
		userId = profileResponse.id
		userName = profileResponse.displayName
		email = profileResponse.email
		phoneNumber = profileResponse.phoneNumber
		updatedAt = 0
		avatar = profileResponse.avatar
	}
}
