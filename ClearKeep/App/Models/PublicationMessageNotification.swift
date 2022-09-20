//
//  PublicationMessageNotification.swift
//  ClearKeep
//
//  Created by Quang Pham on 29/08/2022.
//

import Foundation

class PublicationMessageNotification: Codable {
	var id: String
	var clientId: String
	var fromClientId: String
	var groupId: Int64
	var groupType: String
	var message: Data
	var createdAt: Int64
	var clientWorkspaceDomain: String
	var fromClientWorkspaceDomain: String
	
	enum CodingKeys: String, CodingKey {
		case id = "id"
		case clientId = "client_id"
		case fromClientId = "from_client_id"
		case groupId = "group_id"
		case groupType = "group_type"
		case message = "message"
		case createdAt = "created_at"
		case clientWorkspaceDomain = "client_workspace_domain"
		case fromClientWorkspaceDomain = "from_client_workspace_domain"
	}
	
	required init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		id = try container.decode(String.self, forKey: .id)
		clientId = try container.decode(String.self, forKey: .clientId)
		fromClientId = try container.decode(String.self, forKey: .fromClientId)
		groupId = try container.decode(Int64.self, forKey: .groupId)
		groupType = try container.decode(String.self, forKey: .groupType)
		message = try Data(base64Encoded: container.decode(String.self, forKey: .message).data(using: .utf8) ?? Data()) ?? Data()
		createdAt = try container.decode(Int64.self, forKey: .createdAt)
		clientWorkspaceDomain = try container.decode(String.self, forKey: .clientWorkspaceDomain)
		fromClientWorkspaceDomain = try container.decode(String.self, forKey: .fromClientWorkspaceDomain)
	}
}
