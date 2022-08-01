//
//  ProfileViewModels.swift
//  ClearKeep
//
//  Created by MinhDev on 08/06/2022.
//

import Foundation
import Networking
import ChatSecure
import Model

protocol IProfileViewModels {
	var userProfileViewModel: UserProfileViewModel? { get }
	var urlAvatarViewModel: AvatarViewModel? { get }
	var baseViewModels: ProfileBaseViewModel? { get }
	var isMfaEnable: Bool { get }
}

struct ProfileViewModels: IProfileViewModels {
	var userProfileViewModel: UserProfileViewModel?
	var urlAvatarViewModel: AvatarViewModel?
	var baseViewModels: ProfileBaseViewModel?
	var isMfaEnable: Bool = false
}

extension ProfileViewModels {
	
	init(responseUser: IProfileModels, isMfaEnable: Bool) {
		self.init(userProfileViewModel: UserProfileViewModel(user: responseUser.userProfileModel), isMfaEnable: isMfaEnable)
	}

	init(responseAvatar: IProfileModels) {
		self.init(urlAvatarViewModel: AvatarViewModel(urlAvatar: responseAvatar.avatarModel))
	}

	init(responBase: IProfileModels) {
		self.init(baseViewModels: ProfileBaseViewModel(responBase.groupBase))
	}
}
