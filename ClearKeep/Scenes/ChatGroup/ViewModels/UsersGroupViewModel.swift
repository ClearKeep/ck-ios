//
//  UsersGroupViewModel.swift
//  ClearKeep
//
//  Created by MinhDev on 13/06/2022.
//

import Foundation
import Model

struct CreatGroupGetUsersViewModel: Identifiable {
	var id: String
	var displayName: String
	var workspaceDomain: String
	var avatar: String = ""
	var status: StatusType = .undefined

	init(user: IUserInfo?) {
		self.id = user?.id ?? ""
		self.displayName = user?.displayName ?? ""
		self.workspaceDomain = user?.workspaceDomain ?? ""
		self.avatar = user?.avatar ?? ""
	}

	init(id: String, displayName: String, workspaceDomain: String ) {
		self.id = id
		self.displayName = displayName
		self.workspaceDomain = workspaceDomain
	}

	init(searchUser: IUserInfo?, profile: IUser?) {
		self.id = searchUser?.id ?? ""
		self.displayName = searchUser?.displayName ?? ""
		self.workspaceDomain = searchUser?.workspaceDomain ?? ""
		self.avatar = profile?.avatar ?? ""
		self.status = StatusType(rawValue: profile?.status ?? "") ?? .undefined
	}
}
