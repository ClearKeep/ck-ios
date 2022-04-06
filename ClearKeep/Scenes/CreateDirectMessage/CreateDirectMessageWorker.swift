//
//  CreateDirectMessageWorker.swift
//  ClearKeep
//
//  Created by MinhDev on 01/04/2022.
//

import Foundation

protocol ICreateDirectMessageWorker {
	var remoteStore: ICreateDirectMessageRemoteStore { get }
	var inMemoryStore: ICreateDirectMessageInMemoryStore { get }
}

struct CreateDirectMessageWorker {
	let remoteStore: ICreateDirectMessageRemoteStore
	let inMemoryStore: ICreateDirectMessageInMemoryStore
	
	init(remoteStore: ICreateDirectMessageRemoteStore,
		 inMemoryStore: ICreateDirectMessageInMemoryStore) {
		self.remoteStore = remoteStore
		self.inMemoryStore = inMemoryStore
	}
}

extension CreateDirectMessageWorker: ICreateDirectMessageWorker {
}
