//
//  GroupModel.swift
//  ChatSecure
//
//  Created by NamNH on 11/05/2022.
//

import Foundation
import Networking

public protocol IGroupModel {
	var groupId: Int64 { get }
	var groupName: String { get }
	var groupToken: String { get }
	var groupAvatar: String { get }
	var groupType: String { get }
	var createdByClientId: String { get }
	var createdAt: Int64 { get }
	var updatedByClientId: String { get }
	var groupMembers: [IGroupMember] { get }
	var updatedAt: Int64 { get }
	var lastMessageAt: Int64 { get }
	var lastMessage: IMessageModel { get }
	var idLastMessage: String { get }
	var isRegistered: Bool { get }
	var timeSyncMessage: Int64 { get }
}

struct GroupModel: IGroupModel {
	var groupId: Int64
	var groupName: String
	var groupToken: String
	var groupAvatar: String
	var groupType: String
	var createdByClientId: String
	var createdAt: Int64
	var updatedByClientId: String
	var groupMembers: [IGroupMember]
	var updatedAt: Int64
	var lastMessageAt: Int64
	var lastMessage: IMessageModel
	var idLastMessage: String
	var isRegistered: Bool
	var timeSyncMessage: Int64
}

extension GroupModel {
	init(_ groupResponse: Group_GroupObjectResponse) {
		let groupMembers = groupResponse.lstClient.map { clientResponse in
			GroupMember(clientResponse)
		}
		
		self.init(groupId: groupResponse.groupID,
				  groupName: groupResponse.groupName,
				  groupToken: groupResponse.groupRtcToken,
				  groupAvatar: groupResponse.groupAvatar,
				  groupType: groupResponse.groupType,
				  createdByClientId: groupResponse.createdByClientID,
				  createdAt: groupResponse.createdAt,
				  updatedByClientId: groupResponse.updatedByClientID,
				  groupMembers: groupMembers,
				  updatedAt: groupResponse.updatedAt,
				  lastMessageAt: groupResponse.lastMessageAt,
				  lastMessage: MessageModel(groupResponse.lastMessage),
				  idLastMessage: "",
				  isRegistered: groupResponse.isInitialized,
				  timeSyncMessage: 0)
	}
}

public protocol IGroupMember {
	var id: String { get }
	var username: String { get }
	var workspaceDomain: String? { get }
	var avatar: String? { get }
}

public struct GroupMember: IGroupMember {
	public var id: String
	public var username: String
	public var workspaceDomain: String?
	public var avatar: String?
}

extension GroupMember {
	init(_ clientResponse: Group_ClientInGroupResponse) {
		self.init(id: clientResponse.id,
				  username: clientResponse.displayName,
				  workspaceDomain: clientResponse.workspaceDomain)
	}
	
	init(_ clientResponse: Group_ClientReadObject) {
		self.init(id: clientResponse.id,
				  username: clientResponse.displayName,
				  avatar: clientResponse.avatar)
	}
}
