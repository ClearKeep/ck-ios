//
//  SearchGroupViewModel.swift
//  ClearKeep
//
//  Created by MinhDev on 26/07/2022.
//

import Foundation
import Model
import Networking
import SwiftUI
import simd

protocol ISearchGroupViewModels {
	var viewModelGroup: [SearchGroupViewModel] { get }
}

struct SearchGroupViewModels: ISearchGroupViewModels {
	var viewModelGroup: [SearchGroupViewModel]
	init(model: ISearchModels, responseUser: ISearchModels) {

		let dataSearch = model.groupModel?.compactMap { data in
			SearchGroupViewModel(model: data)
		} ?? []
		self.viewModelGroup = model.groupModel?.filter { $0.groupType == "group" }.compactMap { data in
			SearchGroupViewModel(model: data)
		} ?? []
		let group = dataSearch.filter { $0.groupType == "group" }
		let peer = dataSearch.filter { $0.groupType != "group" }

		peer.forEach { users in
			let user = users.groupMembers.filter { $0.userId != DependencyResolver.shared.channelStorage.currentServer?.profile?.userId }.compactMap { members in
				SearchGroupViewModel(modelPeer: members, idGroup: users.groupId)
			}
			user.forEach { data in
				viewModelGroup.append(data)
			}
		}

		group.forEach { data in
			let member = data.groupMembers.filter { $0.domain != DependencyResolver.shared.channelStorage.currentDomain
			}.compactMap { members in
				SearchGroupViewModel(modelMember: members)
			}
			member.forEach { data in
				if !viewModelGroup.contains(where: { $0.userId == data.userId }) {
					viewModelGroup.append(data)
				}

			}
		}
		
		let userdata = responseUser.members?.compactMap { data in
			SearchGroupViewModel(user: data, domain: DependencyResolver.shared.channelStorage.currentDomain)
		}
		userdata?.forEach { data in
			if !viewModelGroup.contains(where: { $0.userId == data.userId }) {
				viewModelGroup.append(data)
			}
		}
	}
}

struct SearchGroupViewModel: IGroupModel {
	var groupId: Int64 = 0
	var groupName: String = ""
	var groupAvatar: String = ""
	var groupType: String = ""
	var createdBy: String = ""
	var createdAt: Int64 = 0
	var updatedBy: String = ""
	var updatedAt: Int64 = 0
	var rtcToken: String = ""
	var groupMembers: [IMemberModel] = []
	var isJoined: Bool = false
	var ownerDomain: String = ""
	var ownerClientId: String = ""
	var lastMessage: IMessageModel? = nil
	var lastMessageAt: Int64 = 0
	var lastMessageSyncTimestamp: Int64 = 0
	var isDeletedUserPeer: Bool = false
	var hasUnreadMessage: Bool = false
	var userId: String = ""
	var userDomain: String = ""
	var hasMessage: Bool = false
}

extension SearchGroupViewModel {
	init(model: IGroupModel) {
		let groupMembers = model.groupMembers.lazyList.map({ SearchMemberViewModel(member: $0) })

		self.init(groupId: model.groupId,
				  groupName: model.groupName,
				  groupAvatar: model.groupAvatar,
				  groupType: model.groupType,
				  createdBy: model.createdBy,
				  createdAt: model.createdAt,
				  updatedBy: model.updatedBy,
				  updatedAt: model.updatedAt,
				  rtcToken: model.rtcToken,
				  groupMembers: groupMembers,
				  isJoined: model.isJoined,
				  ownerDomain: model.ownerDomain,
				  ownerClientId: model.ownerClientId,
				  lastMessageAt: model.lastMessageAt,
				  lastMessageSyncTimestamp: model.lastMessageSyncTimestamp,
				  isDeletedUserPeer: model.isDeletedUserPeer,
				  hasUnreadMessage: model.hasUnreadMessage)
	}

	init(modelMember: IMemberModel) {

		self.init(groupId: Int64(UUID().uuidString.hash),
				  groupName: modelMember.userName,
				  groupAvatar: modelMember.avatar,
				  groupType: "peer",
				  groupMembers: [],
				  userId: modelMember.userId,
				  userDomain: modelMember.domain)
	}

	init(modelPeer: IMemberModel, idGroup: Int64) {

		self.init(groupId: idGroup,
				  groupName: modelPeer.userName,
				  groupAvatar: modelPeer.avatar,
				  groupType: "peer",
				  groupMembers: [],
				  userId: modelPeer.userId,
				  userDomain: modelPeer.domain,
				  hasMessage: true)
	}

	init(user: IUser, domain: String) {
		self.init(groupId: Int64(UUID().uuidString.hash),
				  groupName: user.displayName,
				  groupAvatar: user.avatar,
				  groupType: "denid",
				  groupMembers: [],
				  userId: user.id,
				  userDomain: domain)
	}

	init(creatGroup: IGroupResponseModel?) {
		self.init(
			groupId: creatGroup?.groupID ?? 0,
			groupMembers: [])

	}

	init(id: String, displayName: String, workspaceDomain: String) {
		self.userId = id
		self.groupName = displayName
		self.userDomain = workspaceDomain
	}
}

struct SearchMemberViewModel: IMemberModel {
	var userId: String
	var userName: String
	var domain: String
	var userState: String
	var userStatus: String
	var phoneNumber: String
	var avatar: String
	var email: String
}

extension SearchMemberViewModel {
	init(member: IMemberModel) {
		self.init(userId: member.userId,
				  userName: member.userName,
				  domain: member.domain,
				  userState: member.userState,
				  userStatus: member.userStatus,
				  phoneNumber: member.phoneNumber,
				  avatar: member.avatar,
				  email: member.email)
	}
}
