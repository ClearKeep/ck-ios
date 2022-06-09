//
//  ChatViewModels.swift
//  ClearKeep
//
//  Created by Quang Pham on 10/06/2022.
//

import Foundation
import Model
import CommonUI
import ChatSecure

protocol IChatViewModels {
	var groupViewModel: IGroupModel? { get }
	var messageViewModel: [IMessageViewModel] { get }
}

struct ChatViewModels: IChatViewModels {
	var groupViewModel: IGroupModel?
	var messageViewModel: [IMessageViewModel] = []
}

extension ChatViewModels {
	
	init(responseGroup: IGroupModel, responseMessage: [RealmMessage]) {
		var messages = [MessageViewModel]()
		responseMessage.forEach { message in
			messages.append(MessageViewModel(data: message, members: responseGroup.groupMembers))
		}
		self.init(groupViewModel: responseGroup, messageViewModel: messages)
	}
}
