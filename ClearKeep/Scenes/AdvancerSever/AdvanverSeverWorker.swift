//
//  AdvanverSeverWorker.swift
//  ClearKeep
//
//  Created by MinhDev on 22/03/2022.
//

import Foundation

protocol IAdvanverSeverWorker {
	var remoteStore: IAdvanverSeverRemoteStore { get }
	var inMemoryStore: IAdvanverSeverInMemoryStore { get }
}

struct AdvanverSeverWorker {
	let remoteStore: IAdvanverSeverRemoteStore
	let inMemoryStore: IAdvanverSeverInMemoryStore
	
	init(remoteStore: IAdvanverSeverRemoteStore,
		 inMemoryStore: IAdvanverSeverInMemoryStore) {
		self.remoteStore = remoteStore
		self.inMemoryStore = inMemoryStore
	}
}

extension AdvanverSeverWorker: IAdvanverSeverWorker {
}
