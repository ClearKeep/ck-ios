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
	
	init(_ user: IUserInfoResponse?) {
		id = user?.id ?? ""
		displayName = user?.displayName ?? ""
		workspaceDomain = user?.workspaceDomain ?? ""
	}
}
