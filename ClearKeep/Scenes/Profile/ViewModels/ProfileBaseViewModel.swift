//
//  ProfileBaseViewModel.swift
//  ClearKeep
//
//  Created by MinhDev on 05/07/2022.
//

import Model
import ChatSecure
import Networking

struct ProfileBaseViewModel {
	var error: String
}

extension ProfileBaseViewModel {
	init(_ response: IGroupBaseResponse?) {
		self.init(error: response?.error ?? "")
	}
}
