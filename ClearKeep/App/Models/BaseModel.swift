//
//  BaseModel.swift
//  ClearKeep
//
//  Created by MinhDev on 22/06/2022.
//

import Model
import ChatSecure
import Networking

struct BaseModel: IBaseResponse {
	var error: String
}

extension BaseModel {
	init(responseGroup: Group_BaseResponse) {
		self.init(error: responseGroup.error)
	}

	init(responseUser: User_BaseResponse) {
		self.init(error: responseUser.error)
	}
}
