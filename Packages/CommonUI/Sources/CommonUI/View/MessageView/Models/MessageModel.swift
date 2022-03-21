//
//  MessageModel.swift
//  
//
//  Created by NamNH on 20/03/2022.
//

import Foundation
import UIKit

public protocol IMessageModel {
	var id: String { get }
	var groupID: Int64 { get }
	var groupType: String { get }
	var fromClientID: String { get }
	var clientID: String { get }
	var message: Data { get }
	var createdAt: Int64 { get }
	var updatedAt: Int64 { get }
	var clientWorkspaceDomain: String { get }
	
}

public struct MessageModel {
	public var id: String
	public var groupID: Int64
	public var groupType: String
	public var fromClientID: String
	public var clientID: String
	public var message: Data
	public var createdAt: Int64
	public var updatedAt: Int64
	public var clientWorkspaceDomain: String
	
	public init(id: String,
		 groupID: Int64,
		 groupType: String,
		 fromClientID: String,
		 clientID: String,
		 message: Data,
		 createdAt: Int64,
		 updatedAt: Int64,
		 clientWorkspaceDomain: String) {
		self.id = id
		self.groupID = groupID
		self.groupType = groupType
		self.fromClientID = fromClientID
		self.clientID = clientID
		self.message = message
		self.createdAt = createdAt
		self.updatedAt = updatedAt
		self.clientWorkspaceDomain = clientWorkspaceDomain
	}
}

extension MessageModel: IMessageModel {}
