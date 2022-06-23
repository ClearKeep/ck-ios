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
	var dateCreated: Int64 { get }
	var isMine: Bool { get }
	var isQuoteMessage: Bool { get }
	var isForwardedMessage: Bool { get }
	var isImageMessage: Bool { get }
	var isFileMessage: Bool { get }
	var clientWorkspaceDomain: String { get }
	
	func dateCreatedString() -> String
	func getQuoteMessage() -> String
	func getQuoteMessageReply() -> String
	func getQuoteMessageTime() -> String
	func getQuoteMessageName() -> String
	
}
