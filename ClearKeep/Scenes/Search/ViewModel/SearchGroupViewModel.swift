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
	var userid: String
	var groupId: Int64
	var groupName: String
	var groupAvatar: String
	var groupType: String
	var createdAt: Int64
	var updatedAt: String
	var hasUnreadMessage: Bool = false
	var groupMembers: [IMemberModel] = []
	var lastMessage: IMessageModel?

	init(group: IGroupModel) {
		self.groupId = group.groupId
		self.userid = ""
		self.groupName = group.groupName
		self.groupAvatar = group.groupAvatar
		self.groupType = group.groupType
		self.hasUnreadMessage = group.hasUnreadMessage
		self.createdAt = group.createdAt
		self.updatedAt = getTimeAsString(timeMs: group.updatedAt)
		self.groupMembers = group.groupMembers
		self.lastMessage = group.lastMessage
	}

	init(member: IMemberModel) {
		self.groupId = 0
		self.userid = member.userId
		self.groupName = member.userName
		self.groupAvatar = member.avatar
		self.groupType = ""
		self.hasUnreadMessage = false
		self.createdAt = 0
		self.updatedAt = ""
		self.groupMembers = []
		self.lastMessage = nil
	}
}
