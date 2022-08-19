//
//  SearchSearchMessageViewModel.swift
//  ClearKeep
//
//  Created by MinhDev on 16/08/2022.
//

import Foundation
import CommonUI
import Model
import ChatSecure

public struct SearchMessageViewModel: Identifiable, Equatable, IMessageViewModel {
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
	public var avatar : String
	public var groupName: String

	public init(data: RealmMessage, members: [IMemberModel], group: String) {
		id = data.messageId
		groupId = data.groupId
		groupType = data.groupType
		fromClientId = data.senderId
		clientId = data.receiverId
		fromClientName = SearchMessageViewModel.getDisplayName(clientId: fromClientId, members: members)
		message = data.message
		dateCreated = data.createdTime
		isMine = SearchMessageViewModel.isMine(senderID: fromClientId, ownerID: data.ownerClientId)
		isQuoteMessage = SearchMessageViewModel.isQuote(message: data.message)
		isForwardedMessage = SearchMessageViewModel.isForwarded(message: data.message)
		isImageMessage = MessageUtils.isImageMessage(message: data.message)
		isFileMessage = MessageUtils.isFileMessage(message: data.message)
		clientWorkspaceDomain = data.ownerDomain
		avatar = SearchMessageViewModel.getAvatar(clientId: fromClientId, members: members)
		groupName = group
	}

	public func dateCreatedString() -> String {
		return SearchMessageViewModel.dateString(from: dateCreated)
	}

	public func getQuoteMessage() -> String {
		if isForwardedMessage {
			return String(message.dropFirst(3))
		}
		let parts = message.dropFirst(3).split(separator: "|")
		if parts.count == 4 {
			return String(parts[1])
		} else {
			return message
		}
	}

	public func getQuoteMessageReply() -> String {
		let parts = message.dropFirst(3).split(separator: "|")
		if parts.count == 4 {
			return String(parts[3])
		} else {
			return ""
		}
	}

	public func getQuoteMessageTime() -> String {
		let parts = message.dropFirst(3).split(separator: "|")
		if parts.count == 4 {
			return String(parts[2])
		} else {
			return ""
		}
	}

	public func getQuoteMessageName() -> String {
		let parts = message.dropFirst(3).split(separator: "|")
		if parts.count == 4 {
			return String(parts[0])
		} else {
			return ""
		}
	}
	
	public func getQuoteMessageId() -> String {
		return ""
	}
	
	public func getQuoteDateString() -> String {
		return ""
	}
}

private extension SearchMessageViewModel {
	static func dateString(from miliseconds: Int64) -> String {
		let date = NSDate(timeIntervalSince1970: TimeInterval(miliseconds / 1000))
		let formatDate = DateFormatter()
		formatDate.dateFormat = "HH:mm"
		return formatDate.string(from: date as Date)
	}

	static func getDisplayName(clientId: String, members: [IMemberModel]) -> String {
		let member = members.first { member in
			member.userId == clientId
		}
		return member?.userName ?? ""
	}

	static func getAvatar(clientId: String, members: [IMemberModel]) -> String {
		let member = members.first { member in
			member.userId == clientId
		}
		return member?.avatar ?? ""
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
