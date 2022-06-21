//
//  SubscribeAndListenService.swift
//  ChatSecure
//
//  Created by NamNH on 17/06/2022.
//

import Foundation
import Networking

public protocol ISubscribeAndListenService {
	func subscribe(_ server: RealmServer)
}

class SubscribeAndListenService {
	private let clientStore: ClientStore

	init(clientStore: ClientStore) {
		self.clientStore = clientStore
	}
}

extension SubscribeAndListenService: ISubscribeAndListenService {
	func subscribe(_ server: RealmServer) {
		var messageRequest = Message_SubscribeRequest()
		messageRequest.deviceID = clientStore.getUniqueDeviceId()
		channelStorage.getChannel(domain: server.serverDomain).subscribe(messageRequest) { result in
			print(result)
		}
		
		var notifyRequest = Notification_SubscribeRequest()
		notifyRequest.deviceID = clientStore.getUniqueDeviceId()
		channelStorage.getChannel(domain: server.serverDomain).subscribe(notifyRequest) { result in
			print(result)
		}
	}
}
