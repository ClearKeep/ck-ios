//
//  NotificationService.swift
//  notificationextension
//
//  Created by NamNH on 12/04/2022.
//

import UserNotifications
import Common
import ChatSecure

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
				print(publication)
				do {
					let realmManager = RealmManager(databasePath: ConfigurationProvider.default.databaseURL)
					let yapDatabase = YapDatabaseManager(databasePath: ConfigurationProvider.default.yapDatabaseURL)
					let clientStore = ClientStore(persistentStoreService: PersistentStoreService(), securedStoreService: SecuredStoreService())
					let channelStorage = ChannelStorage(config: ConfigurationProvider.default, clientStore: clientStore, realmManager: realmManager)
					let signalStore = SignalProtocolInMemoryStore(storage: yapDatabase, channelStorage: channelStorage)
					let senderStore = SenderKeyInMemoryStore(storage: yapDatabase, channelStorage: channelStorage)
					let messageService = MessageService(clientStore: clientStore, signalStore: signalStore, senderStore: senderStore, channelStorage: channelStorage)
					let publication = try JSONDecoder().decode(PublicationMessageNotification.self, from: jsonData)
					channelStorage.updateTempServer(server: TempServer(serverDomain: publication.clientWorkspaceDomain, ownerClientId: publication.clientId))
					let senderName = realmManager.getSenderName(fromClientId: publication.fromClientId, groupId: publication.groupId, domain: publication.clientWorkspaceDomain, ownerId: publication.clientId)
					if publication.groupType == "peer" {
						let message = messageService.decryptPeerMessage(senderName: publication.fromClientId, message: publication.message, messageId: publication.id)
						bestAttemptContent.title = senderName
						bestAttemptContent.body = message ?? "x"
						contentHandler(bestAttemptContent)
					} else {
						let groupName = realmManager.getGroupName(by: publication.groupId, domain: publication.clientWorkspaceDomain, ownerId: publication.clientId)
						Task {
							let message = await messageService.decryptGroupMessage(senderId: publication.fromClientId, senderDomain: publication.fromClientWorkspaceDomain, ownerId: publication.clientId, ownerDomain: publication.clientWorkspaceDomain, groupID: publication.groupId, message: publication.message, messageId: publication.id)
							bestAttemptContent.title = groupName
							bestAttemptContent.body = "\(senderName): \(message ?? "x")"
							contentHandler(bestAttemptContent)
						}
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
