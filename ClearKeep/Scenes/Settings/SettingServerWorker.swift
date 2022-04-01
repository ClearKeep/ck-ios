//
//  SettingServerWorker.swift
//  ClearKeep
//
//  Created by đông on 02/04/2022.
//

import UIKit
import Combine
import Common

protocol ISettingServerWorker {
	var remoteStore: ISettingServerRemoteStore { get }
	var inMemoryStore: ISettingServerInMemoryStore { get }
}

struct SettingServerWorker {
	let remoteStore: ISettingServerRemoteStore
	let inMemoryStore: ISettingServerInMemoryStore

	init(remoteStore: ISettingServerRemoteStore, inMemoryStore: ISettingServerInMemoryStore) {
		self.remoteStore = remoteStore
		self.inMemoryStore = inMemoryStore
	}
}

extension SettingServerWorker: ISettingServerWorker {
}
