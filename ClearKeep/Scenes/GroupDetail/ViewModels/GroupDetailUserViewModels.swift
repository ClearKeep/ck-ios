//
//  GroupDetailUserViewModels.swift
//  ClearKeep
//
//  Created by MinhDev on 27/06/2022.
//

import Foundation
import Model

struct GroupDetailUserViewModels: Identifiable {
	var id: String
	var displayName: String
	var workspaceDomain: String
	var avatar: String

	init(user: IUserInfo?) {
		id = user?.id ?? ""
		displayName = user?.displayName ?? ""
		workspaceDomain = user?.workspaceDomain ?? ""
		avatar = user?.avatar ?? ""
	}

	init(profile: IUser?) {
		id = profile?.id ?? ""
		displayName = profile?.displayName ?? ""
		workspaceDomain = ""
		avatar = profile?.avatar ?? ""
	}

	init(id: String, displayName: String, workspaceDomain: String, avatar: String) {
		self.id = id
		self.displayName = displayName
		self.workspaceDomain = workspaceDomain
		self.avatar = avatar
	}
}
