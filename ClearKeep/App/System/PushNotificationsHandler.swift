//
//  PushNotificationsHandler.swift
//  CountriesSwiftUI
//
//  Created by Alexey Naumov on 26.04.2020.
//  Copyright © 2020 Alexey Naumov. All rights reserved.
//

import UserNotifications

typealias NotificationPayload = [AnyHashable: Any]

protocol IPushNotificationsHandler { }

class PushNotificationsHandler: NSObject, IPushNotificationsHandler {
	
	private let deepLinksHandler: DeepLinksHandler
	private let container: DIContainer
	
	init(deepLinksHandler: DeepLinksHandler, container: DIContainer) {
		self.deepLinksHandler = deepLinksHandler
		self.container = container
		super.init()
		UNUserNotificationCenter.current().delegate = self
	}
}

// MARK: - UNUserNotificationCenterDelegate

extension PushNotificationsHandler: UNUserNotificationCenterDelegate {
	
	func userNotificationCenter(_ center: UNUserNotificationCenter,
								willPresent notification: UNNotification,
								withCompletionHandler completionHandler:
								@escaping (UNNotificationPresentationOptions) -> Void) {
		completionHandler([.banner, .sound, .list])
	}
	
	func userNotificationCenter(_ center: UNUserNotificationCenter,
								didReceive response: UNNotificationResponse,
								withCompletionHandler completionHandler: @escaping () -> Void) {
		let userInfo = response.notification.request.content.userInfo
		print("notification payload: \(userInfo)")
		handleNotification(userInfo: userInfo, completionHandler: completionHandler)
	}
	
	func handleNotification(userInfo: [AnyHashable: Any], completionHandler: @escaping () -> Void) {
		if let jsonString = userInfo["publication"] as? String,
		   let jsonData = jsonString.data(using: .utf8) {
			do {
				let publication = try JSONDecoder().decode(PublicationMessageNotification.self, from: jsonData)
				//container.appState[\.authentication.selectedGroupId] = publication.groupId
				completionHandler()
			} catch {
				completionHandler()
			}
		} else {
			completionHandler()
		}
	}
}

private class PublicationMessageNotification: Codable {
	var id: String
	var clientId: String
	var fromClientId: String
	var groupId: Int64
	var groupType: String
	var message: Data
	var createdAt: Int64
	var clientWorkspaceDomain: String
	
	enum CodingKeys: String, CodingKey {
		case id = "id"
		case clientId = "client_id"
		case fromClientId = "from_client_id"
		case groupId = "group_id"
		case groupType = "group_type"
		case message = "message"
		case createdAt = "created_at"
		case clientWorkspaceDomain = "client_workspace_domain"
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
	}
}
