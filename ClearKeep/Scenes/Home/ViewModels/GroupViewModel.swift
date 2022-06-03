//
//  GroupViewModel.swift
//  ClearKeep
//
//  Created by NamNH on 17/05/2022.
//

import Foundation
import Model

struct GroupViewModel: Identifiable {
	var id: String { "\(groupId)" }
	var groupId: Int64
	var groupName: String
	var groupAvatar: String
	var groupType: String
	var hasUnreadMessage: Bool = false
	
	init(_ model: IGroupModel) {
		self.groupId = model.groupId
		self.groupName = model.groupName
		self.groupAvatar = model.groupAvatar
		self.groupType = model.groupType
		self.hasUnreadMessage = model.hasUnreadMessage
	}
}

protocol IGroupViewModels {
	var viewModelGroup: [IGroupModel] { get }
}

struct GroupViewModels: IGroupViewModels {
	var viewModelGroup: [IGroupModel]
	init(_ model: IHomeModels) {
		self.viewModelGroup = model.groupModel ?? [IGroupModel]()
	}
}
