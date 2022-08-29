//
//  MessageViewModel.swift
//  ClearKeep
//
//  Created by Quang Pham on 10/06/2022.
//

import CommonUI
import Model
import Common

public struct MessageViewModel: Identifiable, Equatable, IMessageViewModel {
	public var id: String
	public var groupId: Int64
	public var groupType: String
	public var fromClientId: String
	public var fromClientName: String
	public var clientId: String
	public var message: String
	public var dateCreated: Int64
	public var isMine: Bool
	public var isQuoteMessage: Bool
	public var isForwardedMessage: Bool
	public var isImageMessage: Bool
	public var isFileMessage: Bool
	public var clientWorkspaceDomain: String
	
	public init(data: IMessageModel, members: [IMemberModel]) {
		id = data.messageId
		groupId = data.groupId
		groupType = data.groupType
		fromClientId = data.senderId
		clientId = data.receiverId
		fromClientName = MessageViewModel.getDisplayName(clientId: fromClientId, members: members)
		message = data.message
		dateCreated = data.createdTime
		isMine = MessageViewModel.isMine(senderID: fromClientId, ownerID: data.ownerClientId)
		isQuoteMessage = MessageViewModel.isQuote(message: data.message)
		isForwardedMessage = MessageViewModel.isForwarded(message: data.message)
		isImageMessage = MessageUtils.isImageMessage(message: data.message)
		isFileMessage = MessageUtils.isFileMessage(message: data.message)
		clientWorkspaceDomain = data.ownerDomain
	}
	
	public init(data: RealmMessage, members: [IMemberModel]) {
		id = data.messageId
		groupId = data.groupId
		groupType = data.groupType
		fromClientId = data.senderId
		clientId = data.receiverId
		fromClientName = MessageViewModel.getDisplayName(clientId: fromClientId, members: members)
		message = data.message
		dateCreated = data.createdTime
		isMine = MessageViewModel.isMine(senderID: fromClientId, ownerID: data.ownerClientId)
		isQuoteMessage = MessageViewModel.isQuote(message: data.message)
		isForwardedMessage = MessageViewModel.isForwarded(message: data.message)
		isImageMessage = MessageUtils.isImageMessage(message: data.message)
		isFileMessage = MessageUtils.isFileMessage(message: data.message)
		clientWorkspaceDomain = data.ownerDomain
	}
	
	public func dateCreatedString() -> String {
		return MessageViewModel.dateString(from: dateCreated)
	}
	
	public func getQuoteDateString() -> String {
		return MessageViewModel.quoteDateString(from: getQuoteMessageTime())
	}
	
	public func getQuoteMessage() -> String {
		if isForwardedMessage {
			return String(message.dropFirst(3))
		}
		let parts = message.dropFirst(3).split(separator: "|")
		if parts.count == 5 {
			return String(parts[1])
		} else {
			return message
		}
	}
	
	public func getQuoteMessageReply() -> String {
		let parts = message.dropFirst(3).split(separator: "|")
		if parts.count == 5 {
			return String(parts[4])
		} else {
			return ""
		}
	}
	
	public func getQuoteMessageTime() -> String {
		let parts = message.dropFirst(3).split(separator: "|")
		if parts.count == 5 {
			return String(parts[2])
		} else {
			return ""
		}
	}
	
	public func getQuoteMessageName() -> String {
		let parts = message.dropFirst(3).split(separator: "|")
		if parts.count == 5 {
			return String(parts[0])
		} else {
			return ""
		}
	}
	
	public func getQuoteMessageId() -> String {
		let parts = message.dropFirst(3).split(separator: "|")
		if parts.count == 5 {
			return String(parts[3])
		} else {
			return ""
		}
	}
}

private extension MessageViewModel {
	static func dateString(from miliseconds: Int64) -> String {
		let date = NSDate(timeIntervalSince1970: TimeInterval(miliseconds / 1000))
		let formatDate = DateFormatter()
		formatDate.dateFormat = "HH:mm"
		return formatDate.string(from: date as Date)
	}
	
	static func quoteDateString(from miliseconds: String) -> String {
		guard let dateMilliseconds = Int64(miliseconds) else { return "" }
		let date = NSDate(timeIntervalSince1970: TimeInterval(dateMilliseconds / 1000))
		let formatDate = DateFormatter()
		formatDate.dateFormat = "HH:mm dd/MM"
		return formatDate.string(from: date as Date)
	}
	
	static func getDisplayName(clientId: String, members: [IMemberModel]) -> String {
		let member = members.first { member in
			member.userId == clientId
		}
		return member?.userName ?? ""
	}
	
	static func isMine(senderID: String, ownerID: String) -> Bool {
		return senderID == ownerID
	}
	
	static func isQuote(message: String) -> Bool {
		return message.starts(with: "```")
	}
	
	static func isForwarded(message: String) -> Bool {
		return message.starts(with: ">>>")
	}
}
