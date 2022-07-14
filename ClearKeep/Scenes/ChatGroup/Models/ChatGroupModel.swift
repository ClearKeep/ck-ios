//
//  ChatGroupModel.swift
//  ClearKeep
//
//  Created by đông on 28/03/2022.
//

import UIKit
import Model
import ChatSecure
import Networking

protocol IGroupChatModel {
	//	var id: Int { get }
	//	var title: String { get }
}

struct GroupChatModel: Identifiable {
	var id = UUID()
	var name: String
	var checked: Bool
}

extension GroupChatModel: IGroupChatModel {}

protocol IGroupChatModels {
	var searchUserModel: IGetUserResponse? { get }
	var creatGroupModel: IGroupResponseModel? { get }
	var getProfileModel: IUser? { get }
	var getProfileModelWithLink: IUserInfo? { get }
	var searchUserModelWithEmail: IGetUserResponse? { get }
}

struct GroupChatModels: IGroupChatModels {
	var searchUserModel: IGetUserResponse?
	var creatGroupModel: IGroupResponseModel?
	var getProfileModel: IUser?
	var getProfileModelWithLink: IUserInfo?
	var searchUserModelWithEmail: IGetUserResponse?
}

extension GroupChatModels {

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
	
	init(searchUserWithEmail: User_FindUserByEmailResponse) {
		self.init(searchUserModelWithEmail: UserResponseModel(searchUser: searchUserWithEmail))
	}
}
