//
//  CallNotification.swift
//  ChatSecure
//
//  Created by HOANDHTB on 21/07/2022.
//

import UIKit
import Foundation

// MARK: - CallNotification
struct CallNotification: Codable {
	let publication: PublicationNotification?
	let aps: ApsNotification?
}

// MARK: - Aps
struct ApsNotification: Codable {
}

// MARK: - Publication
public struct PublicationNotification: Codable {
	public let turnServer, clientWorkspaceDomain, groupRTCURL, notifyType: String?
	public let groupType, groupName: String?
	public let fromClientAvatar: String?
	public let stunServer, groupID, groupRTCID, fromClientID: String?
	public let fromClientName, clientID, callType, groupRTCToken: String?

	enum CodingKeys: String, CodingKey {
		case turnServer = "turn_server"
		case clientWorkspaceDomain = "client_workspace_domain"
		case groupRTCURL = "group_rtc_url"
		case notifyType = "notify_type"
		case groupType = "group_type"
		case groupName = "group_name"
		case fromClientAvatar = "from_client_avatar"
		case stunServer = "stun_server"
		case groupID = "group_id"
		case groupRTCID = "group_rtc_id"
		case fromClientID = "from_client_id"
		case fromClientName = "from_client_name"
		case clientID = "client_id"
		case callType = "call_type"
		case groupRTCToken = "group_rtc_token"
	}
}
