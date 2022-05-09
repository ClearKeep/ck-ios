//
//  MessageViewModel.swift
//
//  Created by NamNH on 20/03/2022.
//

import SwiftUI

public protocol IMessageViewModel {
	var id: String { get }
	var groupId: Int64 { get }
	var groupType: String { get }
	var fromClientId: String { get }
	var fromClientName: String { get }
	var clientId: String { get }
	var message: String { get }
	var dateCreated: String { get }
	var isMine: Bool { get }
	var clientWorkspaceDomain: String { get }
}

public struct MessageViewModel: Identifiable, Equatable, IMessageViewModel {
	public var id: String
	public var groupId: Int64
	public var groupType: String
	public var fromClientId: String
	public var fromClientName: String
	public var clientId: String
	public var message: String
	public var dateCreated: String
	public var isMine: Bool
	public var clientWorkspaceDomain: String
	
	public init(data: IMessageModel) {
		id = data.id
		groupId = data.groupID
		groupType = data.groupType
		fromClientId = data.fromClientID
		clientId = data.clientID
		fromClientName = MessageViewModel.getDisplayName(clientId: fromClientId, groupId: groupId)
		message = data.message.stringUTF8 ?? ""
		dateCreated = MessageViewModel.dateString(from: data.createdAt)
		isMine = MessageViewModel.isMine(clientId: fromClientId)
		clientWorkspaceDomain = data.clientWorkspaceDomain
	}
}

private extension MessageViewModel {
	static func dateString(from miliseconds: Int64) -> String {
		let date = NSDate(timeIntervalSince1970: TimeInterval(miliseconds / 1000))
		let formatDate = DateFormatter()
		formatDate.dateFormat = "HH:mm"
		return formatDate.string(from: date as Date)
	}
	
	static func getDisplayName(clientId: String, groupId: Int64) -> String {
		return ""
	}
	
	static func isMine(clientId: String) -> Bool {
		return clientId == "1"
	}
}
