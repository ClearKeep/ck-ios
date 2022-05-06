//
//  SocialLoginModel.swift
//  ClearKeep
//
//  Created by NamNH on 29/04/2022.
//

import Model
import Networking

struct SocialLoginModel: ISocialLoginModel {
	var userName: String?
	var requireAction: String?
	var resetPincodeToken: String?
}

extension SocialLoginModel {
	init(response: Auth_SocialLoginRes) {
		self.init(userName: response.userName,
				  requireAction: response.requireAction,
				  resetPincodeToken: response.resetPincodeToken)
	}
}
