//
//  GroupDetailViewModels.swift
//  ClearKeep
//
//  Created by MinhDev on 23/06/2022.
//
import Foundation
import Model

protocol IGroupDetailViewModels {
	var getGroup: GroupDetailViewModel? { get }
	var getClientInGroup: [GroupDetailClientViewModel]? { get }
}

struct GroupDetailViewModels: IGroupDetailViewModels {
	var getGroup: GroupDetailViewModel?
	var getClientInGroup: [GroupDetailClientViewModel]?
}

extension GroupDetailViewModels {

	init(groups: IGroupDetaiModels) {
		let group = groups.groupModel.map { member in
			GroupDetailViewModel(member)
		}
		self.init(getGroup: group)
	}

	init(clients: IGroupDetaiModels) {
		let client = clients.groupModel?.groupMembers.map { member in
			GroupDetailClientViewModel(member)
		}
		self.init(getClientInGroup: client)
	}
}
