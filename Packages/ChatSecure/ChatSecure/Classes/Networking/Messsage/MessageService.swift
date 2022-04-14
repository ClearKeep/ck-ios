//
//  MessageService.swift
//  ChatSecure
//
//  Created by NamNH on 13/04/2022.
//

import Foundation
import Networking

protocol IMessageService {
	func sendMessageInPeer(senderId: String,
						   ownerWorkspace: String,
						   receiverId: String,
						   receiverWorkSpaceDomain: String,
						   groupId: Int64,
						   plainMessage: String,
						   isForceProcessKey: Bool,
						   cachedMessageId: Int) async
	
	func sendMessageInGroup(senderId: String,
						   ownerWorkspace: String,
						   receiverId: String,
						   groupId: Int64,
						   plainMessage: String,
						   cachedMessageId: Int) async
}

class MessageService {
	var clientStore: ClientStore
	
	public init() {
		clientStore = ClientStore()
	}
}

extension MessageService: IMessageService {
	func sendMessageInPeer(senderId: String, ownerWorkspace: String, receiverId: String, receiverWorkSpaceDomain: String, groupId: Int64, plainMessage: String, isForceProcessKey: Bool, cachedMessageId: Int) async {
		
	}
	
	func sendMessageInGroup(senderId: String, ownerWorkspace: String, receiverId: String, groupId: Int64, plainMessage: String, cachedMessageId: Int) async {
		
	}
}
