//
//  AvatarViewModel.swift
//  ClearKeep
//
//  Created by MinhDev on 05/07/2022.
//

import Foundation
import Model

struct AvatarViewModel: IUserAvatar {
	var fileURL: String

	init(urlAvatar: IUserAvatar?) {
		fileURL = urlAvatar?.fileURL ?? ""
	}
}
