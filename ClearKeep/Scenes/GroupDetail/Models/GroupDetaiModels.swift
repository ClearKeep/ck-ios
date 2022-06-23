//
//  GroupDetaiModel.swift
//  ClearKeep
//
//  Created by MinhDev on 23/06/2022.
//

import Model
import Networking
import ChatSecure

protocol IGroupDetaiModels {
	var groupModel: [IGroupModel]? { get }
	var groupBase: IGroupBaseResponse? { get }
}

struct GroupDetaiModels: IGroupDetaiModels{
	var groupModel: [IGroupModel]?
	var groupBase: IGroupBaseResponse?
}

extension GroupDetaiModels {
	init(responseGroup: [GroupModel]) {
		self.init(groupModel: responseGroup)
	}

	init(responseError: Group_BaseResponse) {
		self.init(groupBase: GroupBaseModel(responseError))
	}
}
