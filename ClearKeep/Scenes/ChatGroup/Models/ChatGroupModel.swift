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
}

struct GroupChatModels: IGroupChatModels {
	var searchUserModel: IGetUserResponse?
	var creatGroupModel: IGroupResponseModel?
	var getProfileModel: IUser?
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

}
