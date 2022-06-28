//
//  SubscribeAndListenService.swift
//  ChatSecure
//
//  Created by NamNH on 17/06/2022.
//

import Foundation
import Networking

public protocol ISubscribeAndListenService {
	func subscribe(_ serverDomain: String)
}

public class SubscribeAndListenService {
	private let clientStore: ClientStore

	public init(clientStore: ClientStore) {
		self.clientStore = clientStore
	}
}

extension SubscribeAndListenService: ISubscribeAndListenService {
	public func subscribe(_ serverDomain: String) {
		var messageRequest = Message_SubscribeRequest()
		messageRequest.deviceID = clientStore.getUniqueDeviceId()
		channelStorage.getChannel(domain: serverDomain).subscribe(messageRequest) { result in
			print("message subscribe for \(serverDomain) \(result)")
		}
		
		var notifyRequest = Notification_SubscribeRequest()
		notifyRequest.deviceID = clientStore.getUniqueDeviceId()
		channelStorage.getChannel(domain: serverDomain).subscribe(notifyRequest) { result in
			print("notification subscribe for \(serverDomain) \(result)")
		}
	}
}
