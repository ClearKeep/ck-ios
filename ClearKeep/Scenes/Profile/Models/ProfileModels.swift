//
//  IProfileModels.swift
//  ClearKeep
//
//  Created by MinhDev on 08/06/2022.
//

import Model
import Networking
import ChatSecure

protocol IProfileModels {
	var avatarModel: IUserAvatar? { get }
	var userProfileModel: IUser? { get }
	var groupBase: IBaseResponse? { get }
}

struct ProfileModels: IProfileModels {
	var avatarModel: IUserAvatar?
	var userProfileModel: IUser?
	var groupBase: IBaseResponse?
}

extension ProfileModels {
	init(responseAvatar: User_UploadAvatarResponse) {
		self.init(avatarModel: AvatarModel(response: responseAvatar))
	}

	init(responseProfile: User_UserProfileResponse) {
		self.init(userProfileModel: ProfieModel(profile: responseProfile))
	}
	
	init(responseError: User_BaseResponse) {
		self.init(groupBase: BaseModel(responseUser: responseError))
	}
}
