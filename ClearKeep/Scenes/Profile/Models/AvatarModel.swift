//
//  AvatarModel.swift
//  ClearKeep
//
//  Created by MinhDev on 08/06/2022.
//

import Model
import Networking
import ChatSecure

protocol IUserAvatar {
	var fileURL: String { get }
}
struct AvatarModel: IUserAvatar {
	var fileURL: String
}

extension AvatarModel {
	init(response: User_UploadAvatarResponse) {
		self.init(fileURL: response.fileURL)
	}
}
