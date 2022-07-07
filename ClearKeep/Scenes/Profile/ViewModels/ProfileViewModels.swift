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
}

struct ProfileViewModels: IProfileViewModels {
	var userProfileViewModel: UserProfileViewModel?
	var urlAvatarViewModel: AvatarViewModel?
	var baseViewModels: ProfileBaseViewModel?
}

extension ProfileViewModels {
	
	init(responseUser: IProfileModels) {
		self.init(userProfileViewModel: UserProfileViewModel(user: responseUser.userProfileModel))
	}

	init(responseAvatar: IProfileModels, responseUser: IProfileModels) {
		self.init(urlAvatarViewModel: AvatarViewModel(urlAvatar: responseAvatar.avatarModel))
		self.init(userProfileViewModel: UserProfileViewModel(user: responseUser.userProfileModel))
	}

	init(responBase: IProfileModels) {
		self.init(baseViewModels: ProfileBaseViewModel(responBase.groupBase))
	}
}
