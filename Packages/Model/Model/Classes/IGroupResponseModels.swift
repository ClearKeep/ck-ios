//
//  IGroupResponse.swift
//  _NIODataStructures
//
//  Created by MinhDev on 09/06/2022.
//

import Foundation

public protocol IGroupResponseModel {
	var groupID: Int64 { get }
	var groupName: String { get }
	var groupAvatar: String { get }
	var groupType: String { get }
	var lstClient: [IClientInGroupModel] { get }
	var lastMessageAt: Int64 { get }
	var lastMessage: IGroupMessageResponse { get }
	var hasLastMessage: Bool { get }
	var createdByClientID: String { get }
	var createdAt: Int64 { get }
	var updatedByClientID: String { get }
	var updatedAt: Int64 { get }
	var groupRtcToken: String { get }
	var hasUnreadMessage: Bool { get }
	var clientKey: IGroupClientKey { get }
	var hasClientKey: Bool { get }
}

public protocol IClientInGroupModel {
	var id: String { get }
	var displayName: String { get }
	var workspaceDomain: String { get }
}

public protocol IGroupMessageResponse {
	var id: String { get }
	var groupID: Int64 { get }
	var groupType: String { get }
	var fromClientID: String { get }
	var clientID: String { get }
	var message: Data { get }
	var lstClientRead: [IGroupClientRead] { get }
	var createdAt: Int64 { get }
	var updatedAt: Int64 { get }
	var senderMessage: Data { get }

}

public protocol IGroupClientRead {
	var id: String { get }
	var displayName: String { get }
	var avatar: String { get }
}

public protocol IGroupClientKey {
	var workspaceDomain: String { get }
	var clientID: String { get }
	var deviceID: Int32 { get }
	var clientKeyDistribution: Data { get }
	var senderKeyID: Int64 { get }
	var senderKey: Data { get }
	var publicKey: Data { get }
	var privateKey: String { get }
}

public protocol IGroupBaseResponse {
	var error: String { get }
}

public protocol IGroupClientRequest {
	var id: String { get }
	var displayName: String { get }
	var workspaceDomain: String { get }
}
