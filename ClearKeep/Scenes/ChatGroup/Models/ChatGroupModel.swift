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
	var getUserModel: IGetUserResponse? { get }
	var searchUserModel: ISearchUserResponse? { get }
	var creatGroupModel: IGroupResponseModel? { get }
	var getProfileModel: IUser? { get }
	var clientInGroup: [IUserInfoResponse]? { get }
}

struct GroupChatModels: IGroupChatModels {
	var getUserModel: IGetUserResponse?
	var searchUserModel: ISearchUserResponse?
	var creatGroupModel: IGroupResponseModel?
	var getProfileModel: IUser?
	var clientInGroup: [IUserInfoResponse]?
}

extension GroupChatModels {
	init(getUser: User_GetUsersResponse) {
		self.init(getUserModel: CreatGroupGetUserModel(getUser))
	}

	init(searchUser: User_SearchUserResponse) {
		self.init(searchUserModel: CreatGroupSearchUserModel(searchUser))
	}

	init(creatGroups: Group_GroupObjectResponse) {
		self.init(creatGroupModel: CreatGroupModel(creatGroups))
	}

	init(getProfile: User_UserProfileResponse) {
		self.init(getProfileModel: CreatGroupProfieModel(getProfile))
	}

	init(client: [User_UserInfoResponse]) {
		let clients = client.map { member in
			CreatGroupUserInfoModel(member)
		}
		self.init(clientInGroup: clients)
	}
}
