//
//  GroupDetailWorker.swift
//  ClearKeep
//
//  Created by MinhDev on 28/03/2022.
//

import Foundation

protocol IGroupDetailWorker {
	var remoteStore: IGroupDetailRemoteStore { get }
	var inMemoryStore: IGroupDetailInMemoryStore { get }
}

struct GroupDetailWorker {
	let remoteStore: IGroupDetailRemoteStore
	let inMemoryStore: IGroupDetailInMemoryStore
	
	init(remoteStore: IGroupDetailRemoteStore,
		 inMemoryStore: IGroupDetailInMemoryStore) {
		self.remoteStore = remoteStore
		self.inMemoryStore = inMemoryStore
	}
}

extension GroupDetailWorker: IGroupDetailWorker {
}
