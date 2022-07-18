//
//  CreatePeerProfileViewModel.swift
//  ClearKeep
//
//  Created by MinhDev on 29/06/2022.
//

import Foundation
import Model

struct CreatePeerProfileViewModel {
	var id: String
	var displayName: String
	var email: String
	var phoneNumber: String
	var avatar: String

	init(_ user: IUser?) {
		self.id = user?.id ?? ""
		self.displayName = user?.displayName ?? ""
		self.email = user?.email ?? ""
		self.phoneNumber = user?.phoneNumber ?? ""
		self.avatar = user?.avatar ?? ""
	}
}
