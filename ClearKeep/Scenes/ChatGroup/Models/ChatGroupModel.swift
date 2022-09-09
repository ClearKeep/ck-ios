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
	var userModel: IUser? { get }
	var members: [IUser]? { get }
}

struct GroupChatModels: IGroupChatModels {
	var searchUserModel: IGetUserResponse?
	var creatGroupModel: IGroupResponseModel?
	var getProfileModel: IUser?
	var getProfileModelWithLink: IUserInfo?
	var searchUserModelWithEmail: IGetUserResponse?
	var userModel: IUser?
	var members: [IUser]?
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
		self.init(getProfileModelWithLink: UserInfoModel(userInfor: userProfileWithLink))
	}
	
	init(searchUserWithEmail: User_FindUserByEmailResponse) {
		self.init(searchUserModelWithEmail: UserResponseModel(searchUserbyMail: searchUserWithEmail))
	}

	init(responseUser: User_MemberInfoRes?, members: [User_MemberInfoRes]) {
		let memberTeams = members.map { item -> UserModel in
			return UserModel(response: item)
		}
		self.init(userModel: UserModel(response: responseUser), members: memberTeams)
	}
}
