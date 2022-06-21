//
//  CreatGroupViewModel.swift
//  ClearKeep
//
//  Created by MinhDev on 13/06/2022.
//

import Foundation
import Model

struct CreatGroupViewModel {
	var groupID: Int64
	var groupName: String
	var groupAvatar: String
	var groupType: String
	var lstClient: [ClientInGroupViewModel]
	var lastMessageAt: Int64
	var lastMessage: GroupMessageResponseViewModel
	var hasLastMessage: Bool
	var createdByClientID: String
	var createdAt: Int64
	var updatedByClientID: String
	var updatedAt: Int64
	var groupRtcToken: String
	var hasUnreadMessage: Bool
	var clientKey: GroupClientKeyViewModel
	var hasClientKey: Bool
	
	init(_ group: IGroupResponseModel?) {
		let groupMembers = group?.lstClient.map { member in
			ClientInGroupViewModel(member)
		}
		
		let lastMessages = GroupMessageResponseViewModel(group?.lastMessage)
		let clientKeys = GroupClientKeyViewModel(group?.clientKey)
		
		groupID = group?.groupID ?? 0
		groupName = group?.groupName ?? ""
		groupAvatar = group?.groupAvatar ?? ""
		groupType = group?.groupType ?? ""
		lstClient = groupMembers ?? []
		lastMessageAt = group?.lastMessageAt ?? 0
		lastMessage = lastMessages
		hasLastMessage = group?.hasLastMessage ?? false
		createdByClientID = group?.createdByClientID ?? ""
		createdAt = group?.createdAt ?? 0
		updatedByClientID = group?.updatedByClientID ?? ""
		updatedAt = group?.updatedAt ?? 0
		groupRtcToken = group?.groupRtcToken ?? ""
		hasUnreadMessage = group?.hasUnreadMessage ?? false
		clientKey = clientKeys
		hasClientKey = group?.hasClientKey ?? false
	}
}

struct ClientInGroupViewModel: Identifiable {
	var id: String
	var displayName: String
	var workspaceDomain: String
	init(_ clientInGroup: IClientInGroupModel?) {
		id = clientInGroup?.id ?? ""
		displayName = clientInGroup?.displayName ?? ""
		workspaceDomain = clientInGroup?.workspaceDomain ?? ""
	}
}

struct GroupMessageResponseViewModel: Identifiable {
	var id: String
	var groupID: Int64
	var groupType: String
	var fromClientID: String
	var clientID: String
	var message: Data
	var lstClientRead: [GroupClientReadViewModel]
	var createdAt: Int64
	var updatedAt: Int64
	var senderMessage: Data
	
	init(_ messageResponse: IGroupMessageResponse?) {
		let lstClientReads = messageResponse?.lstClientRead.map { member in
			GroupClientReadViewModel(member)
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

struct GroupClientReadViewModel: Identifiable {
	var id: String
	var displayName: String
	var avatar: String
	
	init(_ clientRead: IGroupClientRead?) {
		id = clientRead?.id ?? ""
		displayName = clientRead?.displayName ?? ""
		avatar = clientRead?.avatar ?? ""
	}
}

struct GroupClientKeyViewModel {
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
