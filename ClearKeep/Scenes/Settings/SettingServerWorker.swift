//
//  SettingServerWorker.swift
//  ClearKeep
//
//  Created by đông on 04/04/2022.
//

import ChatSecure

protocol ISettingServerWorker {
	var remoteStore: ISettingServerRemoteStore { get }
	var inMemoryStore: ISettingServerInMemoryStore { get }
	func getServerInfo() -> RealmServer?
}

struct SettingServerWorker {
	let remoteStore: ISettingServerRemoteStore
	let inMemoryStore: ISettingServerInMemoryStore
	
	init(remoteStore: ISettingServerRemoteStore,
		 inMemoryStore: ISettingServerInMemoryStore) {
		self.remoteStore = remoteStore
		self.inMemoryStore = inMemoryStore
	}
}

extension SettingServerWorker: ISettingServerWorker {
	func getServerInfo() -> RealmServer? {
		return inMemoryStore.getServerInfo()
	}
}
