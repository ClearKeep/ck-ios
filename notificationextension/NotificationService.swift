//
//  NotificationService.swift
//  notificationextension
//
//  Created by NamNH on 12/04/2022.
//

import UserNotifications
import Common

class NotificationService: UNNotificationServiceExtension {
	var contentHandler: ((UNNotificationContent) -> Void)?
	var bestAttemptContent: UNMutableNotificationContent?
	
	override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
		self.contentHandler = contentHandler
		bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
		if let bestAttemptContent = bestAttemptContent {
			if let publication = bestAttemptContent.userInfo["publication"],
			   let jsonString = publication as? String,
			   let jsonData = jsonString.data(using: .utf8) {
				do {
					let publication = try JSONDecoder().decode(PublicationMessageNotification.self, from: jsonData)
					let realmManager = RealmManager(databasePath: ConfigurationProvider.default.databaseURL)
					if publication.groupType == "peer" {
						// decrypt peer message
						let senderName = realmManager.getSenderName(fromClientId: publication.fromClientId, groupId: publication.groupId, domain: publication.clientWorkspaceDomain, ownerId: publication.clientId)
						bestAttemptContent.title = senderName
						contentHandler(bestAttemptContent)
					} else {
						// decrypt group message
						let senderName = realmManager.getGroupName(by: publication.groupId, domain: publication.clientWorkspaceDomain, ownerId: publication.clientId)
						bestAttemptContent.title = senderName
						contentHandler(bestAttemptContent)
					}
				} catch {
					bestAttemptContent.body = "\(#function) 1"
					contentHandler(bestAttemptContent)
				}
			} else {
				bestAttemptContent.body = "\(#function) 2"
				contentHandler(bestAttemptContent)
			}
		}
	}
	
	override func serviceExtensionTimeWillExpire() {
		// Called just before the extension will be terminated by the system.
		// Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
		if let contentHandler = contentHandler, let bestAttemptContent = bestAttemptContent {
			contentHandler(bestAttemptContent)
		}
	}
	
}
