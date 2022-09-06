//
//  UserInfoModel.swift
//  ClearKeep
//
//  Created by MinhDev on 22/06/2022.
//

import Model
import ChatSecure
import Networking

struct UserInfoModel: IUserInfo {
	var id: String
	var displayName: String
	var workspaceDomain: String
	var avatar: String
}

extension UserInfoModel {
	init(userResponse: User_UserInfoResponse) {
		self.init(id: userResponse.id,
				  displayName: userResponse.displayName,
				  workspaceDomain: userResponse.workspaceDomain,
				  avatar: userResponse.avatar)
	}

}
