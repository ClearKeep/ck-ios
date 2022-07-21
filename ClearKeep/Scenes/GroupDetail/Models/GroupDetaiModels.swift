//
//  GroupDetailModel.swift
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
	var getProfileModelWithLink: IUserInfo? { get }
	var searchUserModelWithEmail: IGetUserResponse? { get }
}

struct GroupDetailModels: IGroupDetailModels {
	var groupModel: IGroupModel?
	var searchUser: IGetUserResponse?
	var groupBase: IGroupBaseResponse?
	var getProfile: IUser?
	var getProfileModelWithLink: IUserInfo?
	var searchUserModelWithEmail: IGetUserResponse?
}

extension GroupDetailModels {
	init(responseGroup: GroupModel) {
		self.init(groupModel: responseGroup)
	}

	init(searchUser: User_SearchUserResponse) {
		self.init(searchUser: UserResponseModel(searchUser: searchUser))
	}

	init(responseError: Group_BaseResponse) {
		self.init(groupBase: GroupBaseModel(groupResponse: responseError))
	}

	init(getProfile: User_UserProfileResponse) {
		self.init(getProfile: ProfieModel(profile: getProfile))
	}

	init(userProfileWithLink: User_UserInfoResponse) {
		self.init(getProfileModelWithLink: UserInforModel(userInfor: userProfileWithLink))
	}

	init(searchUserWithEmail: User_FindUserByEmailResponse) {
		self.init(searchUserModelWithEmail: UserResponseModel(searchUser: searchUserWithEmail))
	}
}
