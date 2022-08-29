//
//  SettingServerInMemoryStore.swift
//  ClearKeep
//
//  Created by đông on 04/04/2022.
//

import ChatSecure
import Common

protocol ISettingServerInMemoryStore {
	func getServerInfo() -> RealmServer?
}

struct SettingServerInMemoryStore {
	let channelStorage: IChannelStorage
}

extension SettingServerInMemoryStore: ISettingServerInMemoryStore {
	func getServerInfo() -> RealmServer? {
		return channelStorage.currentServer
	}
}
