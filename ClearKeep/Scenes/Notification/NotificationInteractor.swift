//
//  NotificationInteractor.swift
//  ClearKeep
//
//  Created by đông on 04/04/2022.
//

import Common

protocol INotificationInteractor {
	var worker: INotificationWorker { get }
}

struct NotificationInteractor {
	let appState: Store<AppState>
}

extension NotificationInteractor: INotificationInteractor {
	var worker: INotificationWorker {
		let remoteStore = NotificationRemoteStore()
		let inMemoryStore = NotificationInMemoryStore()
		return NotificationWorker(remoteStore: remoteStore, inMemoryStore: inMemoryStore)
	}
}
