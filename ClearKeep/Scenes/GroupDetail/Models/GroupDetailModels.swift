//
//  GroupDetaiModel.swift
//  ClearKeep
//
//  Created by MinhDev on 23/06/2022.
//

import Model
import Networking
import ChatSecure

protocol IGroupDetailModels {
	var groupModel: IGroupModel? { get }
	var searchUser: IGetUserResponse? { get }
	var groupBase: IGroupBaseResponse? { get }
	var getProfile: IUser? { get }
}

struct GroupDetailModels: IGroupDetailModels {
	var groupModel: IGroupModel?
	var searchUser: IGetUserResponse?
	var groupBase: IGroupBaseResponse?
	var getProfile: IUser?
}

extension GroupDetailModels {
	init(responseGroup: GroupModel) {
		self.init(groupModel: responseGroup)
	}

	init(searchUser: User_SearchUserResponse) {
		self.init(searchUser: UserResponseModel(searchUser: searchUser))
	}

	init(responseError: Group_BaseResponse) {
		self.init(groupBase: GroupBaseModel(responseError))
	}

	init(getProfile: User_UserProfileResponse) {
		self.init(getProfile: ProfieModel(profile: getProfile))
	}
}
