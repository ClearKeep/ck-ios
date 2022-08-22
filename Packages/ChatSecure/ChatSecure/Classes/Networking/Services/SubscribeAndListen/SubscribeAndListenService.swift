//
//  SubscribeAndListenService.swift
//  ChatSecure
//
//  Created by NamNH on 17/06/2022.
//

import Common
import Networking
import Model

public protocol ISubscribeAndListenService {
	func subscribe(_ server: RealmServer)
	func unSubscribe(_ server: RealmServer)
}

public class SubscribeAndListenService {
	private let clientStore: ClientStore
	private let messageService: IMessageService

	public init(clientStore: ClientStore, messageService: IMessageService) {
		self.clientStore = clientStore
		self.messageService = messageService
	}
}

extension SubscribeAndListenService: ISubscribeAndListenService {
	public func subscribe(_ server: RealmServer) {
		guard let ownerId = server.profile?.userId else { return }
		let deviceId = clientStore.getUniqueDeviceId()
		var messageRequest = Message_SubscribeRequest()
		messageRequest.deviceID = deviceId
		channelStorage.getChannel(domain: server.serverDomain).subscribe(messageRequest) {
			print("subscribe message channel success")
			self.messageListen(deviceID: deviceId, domain: server.serverDomain, ownerId: ownerId)
		}
		
		var notificationRequest = Notification_SubscribeRequest()
		notificationRequest.deviceID = deviceId
		channelStorage.getChannel(domain: server.serverDomain).subscribe(notificationRequest) {
			print("subscribe notification channel success")
			self.notificationListen(deviceID: deviceId, domain: server.serverDomain)
		}
	}

	public func unSubscribe(_ server: RealmServer) {
		guard let ownerId = server.profile?.userId else { return }
		let deviceId = clientStore.getUniqueDeviceId()
		var messageRequest = Message_UnSubscribeRequest()
		messageRequest.deviceID = deviceId
		channelStorage.getChannel(domain: server.serverDomain).unSubscribe(messageRequest) {
			print("unSubscribe message channel success")
			self.messageListen(deviceID: deviceId, domain: server.serverDomain, ownerId: ownerId)
		}

		var notificationRequest = Notification_UnSubscribeRequest()
		notificationRequest.deviceID = deviceId
		channelStorage.getChannel(domain: server.serverDomain).unSubscribe(notificationRequest) {
			print("unSubscribe notification channel success")
			self.notificationListen(deviceID: deviceId, domain: server.serverDomain)
		}
	}

	
	private func messageListen(deviceID: String, domain: String, ownerId: String) {
		var request = Message_ListenRequest()
		request.deviceID = deviceID
		
		channelStorage.getChannel(domain: domain).listen(request) { response in
			switch response {
			case .success(let publication):
				Debug.DLog("heard from \(publication.fromClientID)")
				Task {
					await self.processIncomingMessage(ownerId: ownerId, domain: domain, message: publication)
				}
			case .failure(let error):
				Debug.DLog("listen message failed", error.localizedDescription)
			}
		}
	}
	
	private func notificationListen(deviceID: String, domain: String) {
		var request = Notification_ListenRequest()
		request.deviceID = deviceID
		
		channelStorage.getChannel(domain: domain).listen(request) { response in
			switch response {
			case .success(let publication):
				self.proccessNotification(notification: publication)
			case .failure(let error):
				Debug.DLog("listen notification failed", error.localizedDescription)
			}
		}
	}
	
	private func proccessNotification(notification: Notification_NotifyObjectResponse) {
		Debug.DLog("received notification", notification)
		let userInfo: [String: Any] = ["notification": notification]
		DispatchQueue.main.async {
			NotificationCenter.default.post(name: NSNotification.Name.SubscribeAndListenService.didReceiveNotification,
											object: nil,
											userInfo: userInfo)
		}
	}
	
	private func processIncomingMessage(ownerId: String, domain: String, message: Message_MessageObjectResponse) async {
		Debug.DLog("received message", message)
		
		var messageModel = MessageModel()
		messageModel.ownerDomain = domain
		messageModel.createdTime = message.createdAt
		messageModel.groupId = message.groupID
		messageModel.receiverId = message.clientID
		messageModel.groupType = message.groupType
		messageModel.senderId = message.fromClientID
		messageModel.messageId = message.id
		messageModel.updatedTime = message.updatedAt
		messageModel.ownerClientId = ownerId
		var decryptedMessage = ""
		if message.groupType == "peer" {
			if message.fromClientID == ownerId {
				decryptedMessage = messageService.decryptPeerMessage(senderName: "\(domain)_\(ownerId)", message: message.senderMessage, messageId: message.id) ?? ""
			} else {
				decryptedMessage = messageService.decryptPeerMessage(senderName: "\(message.fromClientWorkspaceDomain)_\(message.fromClientID)", message: message.message, messageId: message.id) ?? ""
			}
		} else {
			decryptedMessage = await messageService.decryptGroupMessage(senderId: message.fromClientID, senderDomain: message.fromClientWorkspaceDomain, ownerId: ownerId, ownerDomain: domain, groupID: message.groupID, message: message.message) ?? ""
		}
		messageModel.message = decryptedMessage
		channelStorage.realmManager.saveMessage(message: RealmMessage(message: messageModel))
		let userInfo: [String: Any] = ["clientId": ownerId, "message": messageModel]
		
		DispatchQueue.main.async {
			NotificationCenter.default.post(name: NSNotification.Name.SubscribeAndListenService.didReceiveMessage,
											object: nil,
											userInfo: userInfo)
		}
	}
}

extension Notification.Name {
	public enum SubscribeAndListenService {
		public static let didReceiveMessage = Notification.Name("SubscribeAndListenService.didReceiveMessage")
		public static let didReceiveNotification = Notification.Name("SubscribeAndListenService.didReceiveNotification")
	}
}

struct MessageModel: IMessageModel {
	var messageId: String = ""
	var groupId: Int64 = 0
	var groupType: String = ""
	var senderId: String = ""
	var receiverId: String = ""
	var message: String = ""
	var createdTime: Int64 = 0
	var updatedTime: Int64 = 0
	var ownerDomain: String = ""
	var ownerClientId: String = ""
}
