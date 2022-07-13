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
}

extension HomeModels {
	init(responseGroup: [GroupModel]) {
		self.init(groupModel: responseGroup)
	}

	init(responseUser: User_UserProfileResponse) {
		self.init(userModel: UserModel(response: responseUser))
	}
	
	init(responseUser: User_MemberInfoRes?) {
		self.init(userModel: UserModel(response: responseUser))
	}
}
