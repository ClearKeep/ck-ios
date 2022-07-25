//
//  GroupBaseModel.swift
//  ClearKeep
//
//  Created by MinhDev on 22/06/2022.
//

import Model
import ChatSecure
import Networking

struct GroupBaseModel: IGroupBaseResponse {
	var error: String
}

extension GroupBaseModel {
	init(responseGroup: Group_BaseResponse) {
		self.init(error: responseGroup.error)
	}

	init(responseAuthen: Auth_BaseResponse) {
		self.init(error: responseAuthen.error)
	}
}
