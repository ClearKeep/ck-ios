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

struct GroupDetailViewModels {
	var getGroup: GroupDetailViewModel?
}

extension GroupDetailViewModels {

	init(groups: IGroupChatModels) {
		let creatGroups = groups.creatGroupModel.map { member in
			CreatGroupViewModel(member)
		}
		self.init(getGroup: creatGroups)
	}

}
