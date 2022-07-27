//
//  SearchUserViewModel.swift
//  ClearKeep
//
//  Created by MinhDev on 26/07/2022.
//

import Foundation
import Model

struct SearchUserViewModel: Identifiable {
	var id: String
	var displayName: String
	var workspaceDomain: String

	init(_ user: IUserInfo?) {
		id = user?.id ?? ""
		displayName = user?.displayName ?? ""
		workspaceDomain = user?.workspaceDomain ?? ""
	}
}
