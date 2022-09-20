//
//  GroupsModel.swift
//  ClearKeep
//
//  Created by MinhDev on 22/06/2022.
//

import Model
import ChatSecure
import Networking

struct GroupsModel: IGroupsModel {
	var lstGroup: [IGroupResponseModel]
}

extension GroupsModel {
	init(searchGroup: Group_SearchGroupsResponse) {
		let groups = searchGroup.lstGroup.map { member in
			GroupResponseModel(member)
		}
		self.init(lstGroup: groups)
	}
}
