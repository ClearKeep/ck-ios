//
//  SearchGroupModel.swift
//  ClearKeep
//
//  Created by MinhDev on 26/07/2022.
//

import Foundation
import Model
import Networking

struct SearchGroupModels {
	var lstGroup: [GroupResponseModel]?
}

extension SearchGroupModels {

	init(groupResponse: Group_SearchGroupsResponse) {
		let lstGroupData = groupResponse.lstGroup.map { group in
			GroupResponseModel(group)
		}
		self.lstGroup = lstGroupData
	}
}
