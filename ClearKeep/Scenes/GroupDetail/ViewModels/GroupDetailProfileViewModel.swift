//
//  GroupDetailProfileViewModel.swift
//  ClearKeep
//
//  Created by MinhDev on 18/07/2022.
//

import Foundation
import Model

struct GroupDetailProfileViewModel: Identifiable {
	var id: String
	var displayName: String
	var email: String
	var phoneNumber: String
	var avatar: String
	var status: StatusType
	var domain: String

	init(user: IUser?) {
		self.id = user?.id ?? ""
		self.displayName = user?.displayName ?? ""
		self.email = user?.email ?? ""
		self.phoneNumber = user?.phoneNumber ?? ""
		self.avatar = user?.avatar ?? ""
		status = StatusType(rawValue: user?.status ?? "") ?? .undefined
		self.domain = ""
	}
}
