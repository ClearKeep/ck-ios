//
//  CreatGroupUserModel.swift
//  ClearKeep
//
//  Created by MinhDev on 13/06/2022.
//

import Model
import ChatSecure
import Networking

struct CreatGroupSearchUserModel: ISearchUserResponse {
	var lstUser: [IUserInfoResponse]
}

extension CreatGroupSearchUserModel {
	init(_ userResponse: User_SearchUserResponse) {
		let users = userResponse.lstUser.map { member in
			CreatGroupUserInfoModel(member)
		}
		self.init(lstUser: users)
	}
}

struct CreatGroupUserInfoModel: IUserInfoResponse {
	var id: String
	var displayName: String
	var workspaceDomain: String
}

extension CreatGroupUserInfoModel {
	init(_ clientRequest: User_UserInfoResponse) {
		self.init(id: clientRequest.id,
				  displayName: clientRequest.displayName,
				  workspaceDomain: clientRequest.workspaceDomain)
	}
}

struct CreatGroupProfieModel: IUser {
	var id: String
	var displayName: String
	var email: String
	var phoneNumber: String
	var avatar: String
}
extension CreatGroupProfieModel {
	init(_ user: User_UserProfileResponse) {
		self.init(id: user.id,
				  displayName: user.displayName,
				  email: user.email,
				  phoneNumber: user.phoneNumber,
				  avatar: user.avatar)
	}
}
