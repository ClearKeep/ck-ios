//
//  CreatePeerModels.swift
//  ClearKeep
//
//  Created by MinhDev on 17/06/2022.
//

import Foundation
import Model
import Networking

protocol ICreatePeerModels {
	var searchUserModel: IGetUserResponse? { get }
	var creatGroupModel: IGroupResponseModel? { get }
	var getProfileModel: IUser? { get }
	var getProfileModelWithLink: IUserInfo? { get }
	var searchUserModelWithEmail: IUserInfo? { get }
}

struct CreatePeerModels: ICreatePeerModels {
	var searchUserModel: IGetUserResponse?
	var creatGroupModel: IGroupResponseModel?
	var getProfileModel: IUser?
	var getProfileModelWithLink: IUserInfo?
	var searchUserModelWithEmail: IUserInfo?
}

extension CreatePeerModels {
	init(searchUser: User_SearchUserResponse) {
		self.init(searchUserModel: UserResponseModel(searchUser: searchUser))
	}

	init(creatGroups: Group_GroupObjectResponse) {
		self.init(creatGroupModel: GroupResponseModel(creatGroups))
	}
	
	init(getProfile: User_UserProfileResponse) {
		self.init(getProfileModel: ProfieModel(profile: getProfile))
	}
	
	init(userProfileWithLink: User_UserInfoResponse) {
		self.init(getProfileModelWithLink: UserInforModel(userInfor: userProfileWithLink))
	}
	
	init(searchUserWithEmail: User_UserInfoResponse) {
		self.init(searchUserModelWithEmail: UserInforModel(userInfor: searchUserWithEmail))
	}
}
