//
//  AuthenticationModel.swift
//  ClearKeep
//
//  Created by đông on 08/03/2022.
//

import Model
import Networking

struct AuthenticationModel: IAuthenticationModel {
	var normalLogin: INormalLoginModel?
	var socialLogin: ISocialLoginModel?
}

extension AuthenticationModel {
	init(response: Auth_AuthRes) {
		self.init(normalLogin: NormalLoginModel(response: response))
	}
	
	init(response: Auth_SocialLoginRes) {
		self.init(socialLogin: SocialLoginModel(response: response))
	}
}
