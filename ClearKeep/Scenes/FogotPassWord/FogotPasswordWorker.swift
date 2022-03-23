//
//  FogotPasswordWorker.swift
//  ClearKeep
//
//  Created by MinhDev on 22/03/2022.
//

import Foundation

protocol IFogotPasswordWorker {
	var remoteStore: IFogotPasswordRemoteStore { get }
	var inMemoryStore: IFogotPasswordInMemoryStore { get }
}

struct FogotPasswordWorker {
	let remoteStore: IFogotPasswordRemoteStore
	let inMemoryStore: IFogotPasswordInMemoryStore
	
	init(remoteStore: IFogotPasswordRemoteStore,
		 inMemoryStore: IFogotPasswordInMemoryStore) {
		self.remoteStore = remoteStore
		self.inMemoryStore = inMemoryStore
	}
}

extension FogotPasswordWorker: IFogotPasswordWorker {
}
