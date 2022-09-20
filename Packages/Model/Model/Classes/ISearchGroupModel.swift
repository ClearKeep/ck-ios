//
//  ISearchGroupModels.swift
//  Model
//
//  Created by MinhDev on 19/05/2022.
//

import Foundation
import UIKit

public protocol ISearchGroupModel {
	var lstGroup: [ISearchGroupResponseModel] { get }
}
public protocol ISearchGroupResponseModel {
	var groupID: Int64 { get }
	var groupName: String { get }
	var groupAvatar: String { get }
	var groupType: String { get }
	var lstClient: [ISearchClientInGroupResponseModel] { get }
	var lastMessageAt: Int64 { get }
	var createdByClientID: String { get }
	var createdAt: Int64 { get }
	var updatedByClientID: String { get }
	var updatedAt: Int64 { get }
	var groupRtcToken: String { get }
	var hasUnreadMessage: Bool { get }
	var clientKey: ISearchGroupClientKeyObjectModel { get }
	var hasClientKey: Bool { get }
}

public protocol ISearchClientInGroupResponseModel {
	var id: String { get }
	var displayName: String { get }
	var workspaceDomain: String { get }
	var status: String { get }
}

public protocol ISearchGroupClientKeyObjectModel {
	var workspaceDomain: String { get }
	var clientID: String { get }
	var deviceID: Int32 { get }
	var clientKeyDistribution: Data { get }
	var senderKeyID: Int64 { get }
	var senderKey: Data { get }
	var publicKey: Data { get }
	var privateKey: String { get }
}
