//
//  NotificationInteractor.swift
//  ClearKeep
//
//  Created by đông on 04/04/2022.
//

import Common
import ChatSecure

protocol INotificationInteractor {
	var worker: INotificationWorker { get }
	func unSubscribeAndListenServers()
}

struct NotificationInteractor {
	let appState: Store<AppState>
	let channelStorage: IChannelStorage
}

extension NotificationInteractor: INotificationInteractor {
	var worker: INotificationWorker {
		let remoteStore = NotificationRemoteStore()
		let inMemoryStore = NotificationInMemoryStore()
		return NotificationWorker(remoteStore: remoteStore, inMemoryStore: inMemoryStore, channelStorage: channelStorage)
	}
	
	func unSubscribeAndListenServers() {
		worker.unSubscribeAndListenServers()
	}
}

struct StubNotificationInteractor: INotificationInteractor {

	let channelStorage: IChannelStorage

	var worker: INotificationWorker {
		let remoteStore = NotificationRemoteStore()
		let inMemoryStore = NotificationInMemoryStore()
		return NotificationWorker(remoteStore: remoteStore, inMemoryStore: inMemoryStore, channelStorage: channelStorage)
	}

	func unSubscribeAndListenServers() {
		worker.unSubscribeAndListenServers()
	}
}
