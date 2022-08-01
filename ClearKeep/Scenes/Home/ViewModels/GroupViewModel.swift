//
//  GroupViewModel.swift
//  ClearKeep
//
//  Created by NamNH on 17/05/2022.
//

import Foundation
import Model
import CommonUI

protocol IGroupViewModels {
	var viewModelGroup: [IGroupModel] { get }
}

struct GroupViewModels: IGroupViewModels {
	var viewModelGroup: [IGroupModel]
	init(_ model: IHomeModels, responseUser: IHomeModels) {
		self.viewModelGroup = model.groupModel ?? [IGroupModel]()
		self.viewModelGroup = self.viewModelGroup.map { data -> IGroupModel in
			var group = data
			
			let members = group.groupMembers.map { item -> MemberModel in
				let memberStatus = responseUser.members?.first(where: { $0.id == item.userId })
				return MemberModel(userId: item.userId,
							userName: item.userName,
							domain: item.domain,
							userState: memberStatus?.status ?? item.userState,
							userStatus: item.userStatus,
							phoneNumber: item.phoneNumber,
							avatar: memberStatus?.avatar ?? item.avatar,
							email: item.email)
			}
			group.groupMembers = members
			if group.groupType == "peer" {
				let member = members.first(where: { $0.userId != DependencyResolver.shared.channelStorage.currentServer?.profile?.userId ?? "" })
				group.groupAvatar = member?.avatar ?? ""
			}
			return group
		}
		
	}
}

struct GroupViewModel: Identifiable {
	var id: String { "\(groupId)" }
	var groupId: Int64
	var groupName: String
	var groupAvatar: String
	var groupType: String
	var hasUnreadMessage: Bool = false
	var groupMembers: [IMemberModel] = []

	init(_ model: IGroupModel) {
		self.groupId = model.groupId
		self.groupName = model.groupName
		self.groupAvatar = model.groupAvatar
		self.groupType = model.groupType
		self.hasUnreadMessage = model.hasUnreadMessage
		self.groupMembers = model.groupMembers
	}
}
