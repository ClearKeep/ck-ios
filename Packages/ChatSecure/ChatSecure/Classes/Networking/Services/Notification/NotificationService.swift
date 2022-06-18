//
//  NotificationService.swift
//  ChatSecure
//
//  Created by NamNH on 18/06/2022.
//

import Foundation
import Networking

public protocol INotificationService {
	func registerToken(_ token: String, domain: String)
}

public class NotificationService {
	private let clientStore: ClientStore
	
	public init(clientStore: ClientStore) {
		self.clientStore = clientStore
	}
}

extension NotificationService: INotificationService {
	public func registerToken(_ token: String, domain: String) {
		Task {
			var request = NotifyPush_RegisterTokenRequest()
			request.token = token
			request.deviceID = clientStore.getUniqueDeviceId()
			request.deviceType = "ios"
			await channelStorage.getChannel(domain: domain).registerToken(request)
		}
	}
}
