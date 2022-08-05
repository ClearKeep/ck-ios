//
//  SearchGroupViewModel.swift
//  ClearKeep
//
//  Created by MinhDev on 26/07/2022.
//

import Foundation
import Model
import Networking

protocol ISearchGroupViewModels {
	var viewModelGroup: [IGroupModel] { get }
}

struct SearchGroupViewModels: ISearchGroupViewModels {
	var viewModelGroup: [IGroupModel]
	init(_ model: ISearchModels, responseUser: ISearchModels) {
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

struct SearchGroupViewModel: Identifiable {
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
