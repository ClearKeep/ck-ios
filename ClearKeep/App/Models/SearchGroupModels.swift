//
//  SearchGroupModels.swift
//  ClearKeep
//
//  Created by MinhDev on 19/05/2022.
//

import SwiftUI
import Model
import Networking

struct SearchGroupModel: ISearchGroupModel {
	var lstGroup: [ISearchGroupResponseModel]
}

extension SearchGroupModel {
	init(response: Group_SearchGroupsResponse) {
		let lstGroup = response.lstGroup.map { searchGroup in
			SearchGroupResponseModel(response: searchGroup)}
		self.init(lstGroup: lstGroup)
	}
}

struct SearchGroupResponseModel: ISearchGroupResponseModel {
	var groupID: Int64
	var groupName: String
	var groupAvatar: String
	var groupType: String
	var lstClient: [ISearchClientInGroupResponseModel]
	var lastMessageAt: Int64
	var createdByClientID: String
	var createdAt: Int64
	var updatedByClientID: String
	var updatedAt: Int64
	var groupRtcToken: String
	var hasUnreadMessage: Bool
	var clientKey: ISearchGroupClientKeyObjectModel
	var hasClientKey: Bool

	init(response: Group_GroupObjectResponse) {
		let clientKey = SearchGroupClientKeyObjectModel(response: response.clientKey)
		let lstClient = response.lstClient.map { searchlstClient in
			SearchClientInGroupModel(response: searchlstClient)}
		self.groupID = response.groupID
		self.groupName = response.groupName
		self.groupAvatar = response.groupAvatar
		self.groupType = response.groupType
		self.lstClient = lstClient
		self.lastMessageAt = response.lastMessageAt
		self.createdByClientID = response.createdByClientID
		self.createdAt = response.createdAt
		self.updatedByClientID = response.updatedByClientID
		self.updatedAt = response.updatedAt
		self.groupRtcToken = response.groupRtcToken
		self.hasUnreadMessage = response.hasUnreadMessage_p
		self.clientKey = clientKey
		self.hasClientKey = response.hasClientKey
	}
}

struct SearchClientInGroupModel: ISearchClientInGroupResponseModel {
	var id: String
	var displayName: String
	var workspaceDomain: String
	var status: String

	init(response: Group_ClientInGroupResponse) {
		self.id = response.id
		self.displayName = response.displayName
		self.workspaceDomain = response.workspaceDomain
		self.status = response.status
	}
}

struct SearchGroupClientKeyObjectModel: ISearchGroupClientKeyObjectModel {
	var workspaceDomain: String
	var clientID: String
	var deviceID: Int32
	var clientKeyDistribution: Data
	var senderKeyID: Int64
	var senderKey: Data
	var publicKey: Data
	var privateKey: String

	init(response: Group_GroupClientKeyObject) {
		self.workspaceDomain = response.workspaceDomain
			clientID = response.clientID
			deviceID = response.deviceID
			clientKeyDistribution = response.clientKeyDistribution
			senderKeyID = response.senderKeyID
			senderKey = response.senderKey
			publicKey = response.publicKey
			privateKey = response.privateKey
	}
}
