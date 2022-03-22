//
//  AdvancedSeverWorker.swift
//  ClearKeep
//
//  Created by MinhDev on 22/03/2022.
//

import Foundation

protocol IAdvancedSeverWorker {
	var remoteStore: IAdvancedSeverRemoteStore { get }
	var inMemoryStore: IAdvancedSeverInMemoryStore { get }
}

struct AdvancedSeverWorker {
	let remoteStore: IAdvancedSeverRemoteStore
	let inMemoryStore: IAdvancedSeverInMemoryStore
	
	init(remoteStore: IAdvancedSeverRemoteStore,
		 inMemoryStore: IAdvancedSeverInMemoryStore) {
		self.remoteStore = remoteStore
		self.inMemoryStore = inMemoryStore
	}
}

extension AdvancedSeverWorker: IAdvancedSeverWorker {
}
