//
//  ChangePasswordModels.swift
//  ClearKeep
//
//  Created by MinhDev on 28/07/2022.
//

import Model
import Networking
import ChatSecure

protocol IChangePasswordModels {
	var authenResponse: IGroupBaseResponse? { get }
}

struct ChangePasswordModels: IChangePasswordModels {
	var authenResponse: IGroupBaseResponse?
}

extension ChangePasswordModels {
	init(responseError: User_BaseResponse) {
		self.init(authenResponse: GroupBaseModel(useResponse: responseError))
	}
}
