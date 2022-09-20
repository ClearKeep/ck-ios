//
//  SettingServerInteractor.swift
//  ClearKeep
//
//  Created by đông on 04/04/2022.
//

import Common
import ChatSecure

protocol ISettingServerInteractor {
	var worker: ISettingServerWorker { get }
	func getServerInfo() -> IServerSettingModel
}

struct SettingServerInteractor {
	let channelStorage: IChannelStorage
}

extension SettingServerInteractor: ISettingServerInteractor {
	var worker: ISettingServerWorker {
		let remoteStore = SettingServerRemoteStore()
		let inMemoryStore = SettingServerInMemoryStore(channelStorage: channelStorage)
		return SettingServerWorker(remoteStore: remoteStore, inMemoryStore: inMemoryStore)
	}
	
	func getServerInfo() -> IServerSettingModel {
		if let server = worker.getServerInfo() {
			return ServerSettingModel(url: server.serverDomain, name: server.serverName)
		} else {
			return ServerSettingModel()
		}
	}
}

struct StubSettingServerInteractor: ISettingServerInteractor {
	let channelStorage: IChannelStorage
	
	var worker: ISettingServerWorker {
		let remoteStore = SettingServerRemoteStore()
		let inMemoryStore = SettingServerInMemoryStore(channelStorage: channelStorage)
		return SettingServerWorker(remoteStore: remoteStore, inMemoryStore: inMemoryStore)
	}
	
	func getServerInfo() -> IServerSettingModel {
		return ServerSettingModel()
	}
}
