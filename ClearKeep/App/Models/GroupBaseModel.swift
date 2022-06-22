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
	init(_ response: Group_BaseResponse) {
		self.init(error: response.error)
	}
}
