//
//  SearchGroupViewModel.swift
//  ClearKeep
//
//  Created by MinhDev on 26/07/2022.
//

import Foundation
import Model
import Networking

struct SearchGroupViewModel: Identifiable {
	var id: String { "\(groupID)" }
	var groupID: Int64
	var groupName: String
	var groupAvatar: String
	var groupType: String
	var lstClient: [SearchClientInGroupViewModel]
	var lastMessageAt: Int64
	var lastMessage: SearchGroupMessageResponseViewModel
	var hasLastMessage: Bool
	var createdByClientID: String
	var createdAt: Int64
	var updatedByClientID: String
	var updatedAt: Int64
	var groupRtcToken: String
	var hasUnreadMessage: Bool
	var clientKey: SearchGroupClientKeyViewModel
	var hasClientKey: Bool

	init(_ responseGroup: GroupResponseModel) {
		let groupMembers = responseGroup.lstClient.map { member in
			SearchClientInGroupViewModel(member)
		}

		let lastMessages = SearchGroupMessageResponseViewModel(responseGroup.lastMessage)
		let clientKeys = SearchGroupClientKeyViewModel(responseGroup.clientKey)

		self.groupID = responseGroup.groupID
		self.groupName = responseGroup.groupName
		self.groupAvatar = responseGroup.groupAvatar
		self.groupType = responseGroup.groupType
		self.lstClient = groupMembers
		self.lastMessageAt = responseGroup.lastMessageAt
		self.lastMessage = lastMessages
		self.hasLastMessage = responseGroup.hasLastMessage
		self.createdByClientID = responseGroup.createdByClientID
		self.createdAt = responseGroup.createdAt
		self.updatedByClientID = responseGroup.updatedByClientID
		self.updatedAt = responseGroup.updatedAt
		self.groupRtcToken = responseGroup.groupRtcToken
		self.hasUnreadMessage = responseGroup.hasUnreadMessage
		self.clientKey = clientKeys
		self.hasClientKey = responseGroup.hasClientKey
	}
}
struct SearchClientInGroupViewModel: Identifiable {
	var id: String
	var displayName: String
	var workspaceDomain: String
	init(_ clientInGroup: IClientInGroupModel?) {
		id = clientInGroup?.id ?? ""
		displayName = clientInGroup?.displayName ?? ""
		workspaceDomain = clientInGroup?.workspaceDomain ?? ""
	}
}
struct SearchGroupMessageResponseViewModel: Identifiable {
	var id: String
	var groupID: Int64
	var groupType: String
	var fromClientID: String
	var clientID: String
	var message: Data
	var lstClientRead: [SearchGroupClientReadViewModel]
	var createdAt: Int64
	var updatedAt: Int64
	var senderMessage: Data

	init(_ messageResponse: IGroupMessageResponse?) {
		let lstClientReads = messageResponse?.lstClientRead.map { member in
			SearchGroupClientReadViewModel(member)
		}
		id = messageResponse?.id ?? ""
		groupID = messageResponse?.groupID ?? 0
		groupType = messageResponse?.groupType ?? ""
		fromClientID = messageResponse?.fromClientID ?? ""
		clientID = messageResponse?.clientID ?? ""
		message = messageResponse?.message ?? Data()
		lstClientRead = lstClientReads ?? []
		createdAt = messageResponse?.createdAt ?? 0
		updatedAt = messageResponse?.updatedAt ?? 0
		senderMessage = messageResponse?.senderMessage ?? Data()
	}
}

struct SearchGroupClientReadViewModel: Identifiable {
	var id: String
	var displayName: String
	var avatar: String

	init(_ clientRead: IGroupClientRead?) {
		id = clientRead?.id ?? ""
		displayName = clientRead?.displayName ?? ""
		avatar = clientRead?.avatar ?? ""
	}
}

struct SearchGroupClientKeyViewModel {
	var workspaceDomain: String
	var clientID: String
	var deviceID: Int32
	var clientKeyDistribution: Data
	var senderKeyID: Int64
	var senderKey: Data
	var publicKey: Data
	var privateKey: String

	init(_ clientKey: IGroupClientKey?) {
		workspaceDomain = clientKey?.workspaceDomain ?? ""
		clientID = clientKey?.clientID ?? ""
		deviceID = clientKey?.deviceID ?? 0
		clientKeyDistribution = clientKey?.clientKeyDistribution ?? Data()
		senderKeyID = clientKey?.senderKeyID ?? 0
		senderKey = clientKey?.senderKey ?? Data()
		publicKey = clientKey?.publicKey ?? Data()
		privateKey = clientKey?.privateKey ?? ""
	}
}
