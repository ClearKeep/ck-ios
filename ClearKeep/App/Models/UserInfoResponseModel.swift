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
