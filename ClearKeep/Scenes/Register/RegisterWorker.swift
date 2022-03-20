//
//  RegisterWorker.swift
//  ClearKeep
//
//  Created by MinhDev on 07/03/2022.
//

import Foundation

protocol IRegisterWorker {
	var remoteStore: IRegisterRemoteStore { get }
	var inMemoryStore: IRegisterInMemoryStore { get }
}

struct RegisterWorker {
	let remoteStore: IRegisterRemoteStore
	let inMemoryStore: IRegisterInMemoryStore
	
	init(remoteStore: IRegisterRemoteStore,
		 inMemoryStore: IRegisterInMemoryStore) {
		self.remoteStore = remoteStore
		self.inMemoryStore = inMemoryStore
	}
}

extension RegisterWorker: IRegisterWorker {
}
