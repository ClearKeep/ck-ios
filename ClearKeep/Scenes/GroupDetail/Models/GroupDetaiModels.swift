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
	var userModel: IUser? { get }
	var members: [IUser]? { get }
}

struct GroupDetailModels: IGroupDetailModels {
	var groupModel: IGroupModel?
	var searchUser: IGetUserResponse?
	var groupBase: IGroupBaseResponse?
	var getProfile: IUser?
	var getProfileModelWithLink: IUserInfo?
	var searchUserModelWithEmail: IGetUserResponse?
	var userModel: IUser?
	var members: [IUser]?
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
		self.init(getProfileModelWithLink: UserInfoModel(userInfor: userProfileWithLink))
	}

	init(searchUserWithEmail: User_FindUserByEmailResponse) {
		self.init(searchUserModelWithEmail: UserResponseModel(searchUserbyMail: searchUserWithEmail))
	}

	init(responseUser: User_MemberInfoRes?, members: [User_MemberInfoRes]) {
		let memberTeams = members.map { item -> UserModel in
			return UserModel(response: item)
		}
		self.init(userModel: UserModel(response: responseUser), members: memberTeams)
	}

}
