//
//  CreatePeerChatViewModel.swift
//  ClearKeep
//
//  Created by MinhDev on 23/06/2022.
//

import Foundation
import Model

struct CreatePeerChatViewModel {
	var groupID: Int64
	var groupName: String
	var groupAvatar: String
	var groupType: String
	var lstClient: [ClientInPeerViewModel]
	var lastMessageAt: Int64 = 0
	var lastMessage: PeerMessageResponseViewModel?
	var hasLastMessage: Bool = false
	var createdByClientID: String = ""
	var createdAt: Int64 = 0
	var updatedByClientID: String = ""
	var updatedAt: Int64 = 0
	var groupRtcToken: String = ""
	var hasUnreadMessage: Bool
	var clientKey: PeerClientKeyViewModel?
	var hasClientKey: Bool = false

	init(_ group: IGroupResponseModel?) {
		let groupMembers = group?.lstClient.map { member in
			ClientInPeerViewModel(member)
		}

		let lastMessages = PeerMessageResponseViewModel(group?.lastMessage)
		let clientKeys = PeerClientKeyViewModel(group?.clientKey)

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
	
	init(_ group: GroupViewModel) {
		self.groupID = group.groupId
		self.groupName = group.groupName
		self.groupAvatar = group.groupAvatar
		self.groupType = group.groupType
		self.hasUnreadMessage = group.hasUnreadMessage
		let groupMembers = group.groupMembers.map { member in
			ClientInPeerViewModel(member)
		}
		self.lstClient = groupMembers
	}
}

struct ClientInPeerViewModel: Identifiable {
	var id: String
	var displayName: String
	var workspaceDomain: String
	init(_ clientInGroup: IClientInGroupModel?) {
		id = clientInGroup?.id ?? ""
		displayName = clientInGroup?.displayName ?? ""
		workspaceDomain = clientInGroup?.workspaceDomain ?? ""
	}
	
	init(_ clientInGroup: IMemberModel?) {
		id = clientInGroup?.userId ?? ""
		displayName = clientInGroup?.userName ?? ""
		workspaceDomain = clientInGroup?.domain ?? ""
	}
}

struct PeerMessageResponseViewModel: Identifiable {
	var id: String
	var groupID: Int64
	var groupType: String
	var fromClientID: String
	var clientID: String
	var message: Data
	var lstClientRead: [PeerClientReadViewModel]
	var createdAt: Int64
	var updatedAt: Int64
	var senderMessage: Data

	init(_ messageResponse: IGroupMessageResponse?) {
		let lstClientReads = messageResponse?.lstClientRead.map { member in
			PeerClientReadViewModel(member)
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

struct PeerClientReadViewModel: Identifiable {
	var id: String
	var displayName: String
	var avatar: String

	init(_ clientRead: IGroupClientRead?) {
		id = clientRead?.id ?? ""
		displayName = clientRead?.displayName ?? ""
		avatar = clientRead?.avatar ?? ""
	}
}

struct PeerClientKeyViewModel {
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
