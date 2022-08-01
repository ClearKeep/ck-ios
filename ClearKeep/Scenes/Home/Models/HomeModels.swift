//
//  HomeModel.swift
//  ClearKeep
//
//  Created by MinhDev on 02/06/2022.
//

import Model
import Networking
import ChatSecure

struct HomeModels: IHomeModels {
	var groupModel: [IGroupModel]?
	var userModel: IUser?
	var authenRespone: GroupBaseModel?
	var members: [IUser]?
}

extension HomeModels {
	init(responseGroup: [GroupModel]) {
		self.init(groupModel: responseGroup)
	}

	init(responseUser: User_UserProfileResponse) {
		self.init(userModel: UserModel(response: responseUser))
	}

	init(responseUser: User_MemberInfoRes?, members: [User_MemberInfoRes]) {
		let memberTeams = members.map { item -> UserModel in
			return UserModel(response: item)
		}
		self.init(userModel: UserModel(response: responseUser), members: memberTeams)
	}

	init(responeAuthen: Auth_BaseResponse) {
		self.init(authenRespone: GroupBaseModel(responseAuthen: responeAuthen))
	}
}
