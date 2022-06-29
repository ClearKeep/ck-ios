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
}

struct GroupDetailViewModels: IGroupDetailViewModels {
	var getGroup: GroupDetailViewModel?
}

extension GroupDetailViewModels {

	init(groups: IGroupDetaiModels) {
		let group = groups.groupModel.map { member in
			GroupDetailViewModel(member)
		}
		self.init(getGroup: group)
	}

}
