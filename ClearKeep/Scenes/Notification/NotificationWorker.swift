//
//  NotificationWorker.swift
//  ClearKeep
//
//  Created by đông on 04/04/2022.
//

import Foundation

protocol INotificationWorker {
	var remoteStore: INotificationRemoteStore { get }
	var inMemoryStore: INotificationInMemoryStore { get }
}

struct NotificationWorker {
	let remoteStore: INotificationRemoteStore
	let inMemoryStore: INotificationInMemoryStore
	
	init(remoteStore: INotificationRemoteStore,
		 inMemoryStore: INotificationInMemoryStore) {
		self.remoteStore = remoteStore
		self.inMemoryStore = inMemoryStore
	}
}

extension NotificationWorker: INotificationWorker {
}
