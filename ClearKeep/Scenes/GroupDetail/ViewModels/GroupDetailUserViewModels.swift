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

	init(user: IUserInfo?) {
		id = user?.id ?? ""
		displayName = user?.displayName ?? ""
		workspaceDomain = user?.workspaceDomain ?? ""
	}

	init(profile: IUser?) {
		id = profile?.id ?? ""
		displayName = profile?.displayName ?? ""
		workspaceDomain = ""
	}
}
