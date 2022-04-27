//
//  AddServerWorker.swift
//  ClearKeep
//
//  Created by MinhDev on 26/04/2022.
//

import Foundation

protocol IAddServerWorker {
	var remoteStore: IAddServerRemoteStore { get }
	var inMemoryStore: IAddServerInMemoryStore { get }
}

struct AddServerWorker {
	let remoteStore: IAddServerRemoteStore
	let inMemoryStore: IAddServerInMemoryStore
	
	init(remoteStore: IAddServerRemoteStore,
		 inMemoryStore: IAddServerInMemoryStore) {
		self.remoteStore = remoteStore
		self.inMemoryStore = inMemoryStore
	}
}

extension AddServerWorker: IAddServerWorker {
}
