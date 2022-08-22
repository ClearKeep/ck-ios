//
//  NotificationWorker.swift
//  ClearKeep
//
//  Created by đông on 04/04/2022.
//

import Foundation
import ChatSecure

protocol INotificationWorker {
	var remoteStore: INotificationRemoteStore { get }
	var inMemoryStore: INotificationInMemoryStore { get }

	func unSubscribeAndListenServers()
}

struct NotificationWorker {
	let channelStorage: IChannelStorage
	let remoteStore: INotificationRemoteStore
	let inMemoryStore: INotificationInMemoryStore
	
	init(remoteStore: INotificationRemoteStore,
		 inMemoryStore: INotificationInMemoryStore,
		 channelStorage: IChannelStorage) {
		self.remoteStore = remoteStore
		self.inMemoryStore = inMemoryStore
		self.channelStorage = channelStorage
	}
}

extension NotificationWorker: INotificationWorker {

	func unSubscribeAndListenServers() {
		channelStorage.servers.forEach { server in
			let subscribeAndListenService = SubscribeAndListenService(clientStore: DependencyResolver.shared.clientStore, messageService: DependencyResolver.shared.messageService)
			subscribeAndListenService.unSubscribe(server)
		}
	}
}
