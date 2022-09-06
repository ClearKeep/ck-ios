//
//  CreatGroupUserModel.swift
//  ClearKeep
//
//  Created by MinhDev on 13/06/2022.
//

import Model
import ChatSecure
import Networking

struct UserResponseModel: IGetUserResponse {
	var lstUser: [IUserInfo]
}

extension UserResponseModel {
	init(searchUser: User_SearchUserResponse) {
		let users = searchUser.lstUser.map { member in
			UserInfoModel(userResponse: member)
		}
		self.init(lstUser: users)
	}

	init(getUser: User_GetUsersResponse) {
		let users = getUser.lstUser.map { member in
			UserInfoModel(userResponse: member)
		}
		self.init(lstUser: users)
	}

}

struct UserInforModel: IUserInfo {
	var id: String
	var displayName: String
	var workspaceDomain: String
	var avatar: String
}

extension UserInforModel {
	init(userInfor: User_UserInfoResponse) {
		self.id = userInfor.id
		self.workspaceDomain = userInfor.workspaceDomain
		self.displayName = userInfor.displayName
		self.avatar = userInfor.avatar
	}
}
