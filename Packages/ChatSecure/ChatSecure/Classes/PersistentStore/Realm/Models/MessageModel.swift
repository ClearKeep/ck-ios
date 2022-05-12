//
//  MessageModel.swift
//  ChatSecure
//
//  Created by NamNH on 11/05/2022.
//

import Foundation
import Networking

public protocol IMessageModel {
	var id: String { get }
	var groupId: Int64 { get }
	var groupType: String { get }
	var fromClientId: String { get }
	var clientId: String { get }
	var message: Data { get }
	var createdAt: Int64 { get }
	var updatedAt: Int64 { get }
	var senderMessage: Data { get }
	var readMembers: [GroupMember] { get }
}

struct MessageModel: IMessageModel {
	var id: String
	var groupId: Int64
	var groupType: String
	var fromClientId: String
	var clientId: String
	var message: Data
	var createdAt: Int64
	var updatedAt: Int64
	var senderMessage: Data
	var readMembers: [GroupMember]
}

extension MessageModel {
	init(_ messageResponse: Group_MessageObjectResponse) {
		let readMembers = messageResponse.lstClientRead.map {
			GroupMember($0)
		}
		
		self.init(id: messageResponse.id,
				  groupId: messageResponse.groupID,
				  groupType: messageResponse.groupType,
				  fromClientId: messageResponse.fromClientID,
				  clientId: messageResponse.clientID,
				  message: messageResponse.message,
				  createdAt: messageResponse.createdAt,
				  updatedAt: messageResponse.updatedAt,
				  senderMessage: messageResponse.senderMessage,
				  readMembers: readMembers)
	}
}
