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
	
	init(_ user: IUserInfo?) {
		id = user?.id ?? ""
		displayName = user?.displayName ?? ""
		workspaceDomain = user?.workspaceDomain ?? ""
	}

	init(id: String, displayName: String, workspaceDomain: String) {
		self.id = id
		self.displayName = displayName
		self.workspaceDomain = workspaceDomain
	}
}
