//
//  SettingServerInteractor.swift
//  ClearKeep
//
//  Created by đông on 04/04/2022.
//

import Common

protocol ISettingServerInteractor {
	var worker: ISettingServerWorker { get }
}

struct SettingServerInteractor {
	let appState: Store<AppState>
}

extension SettingServerInteractor: ISettingServerInteractor {
	var worker: ISettingServerWorker {
		let remoteStore = SettingServerRemoteStore()
		let inMemoryStore = SettingServerInMemoryStore()
		return SettingServerWorker(remoteStore: remoteStore, inMemoryStore: inMemoryStore)
	}
}
