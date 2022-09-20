//
//  CreatePeerUserViewModel.swift
//  ClearKeep
//
//  Created by MinhDev on 17/06/2022.
//

import Foundation
import Model

struct CreatePeerUserViewModel: Identifiable {
	var id: String
	var displayName: String
	var workspaceDomain: String
	var avatar: String = ""
	var status: StatusType = .undefined

	init(_ user: IUserInfo?) {
		id = user?.id ?? ""
		displayName = user?.displayName ?? ""
		workspaceDomain = user?.workspaceDomain ?? ""
		avatar = user?.avatar ?? ""
	}

	init(id: String, displayName: String, workspaceDomain: String) {
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
