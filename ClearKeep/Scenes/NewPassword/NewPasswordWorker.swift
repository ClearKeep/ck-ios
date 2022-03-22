//
//  NewPasswordWorker.swift
//  ClearKeep
//
//  Created by MinhDev on 22/03/2022.
//

import Foundation

protocol INewPasswordWorker {
	var remoteStore: INewPasswordRemoteStore { get }
	var inMemoryStore: INewPasswordInMemoryStore { get }
}

struct NewPasswordWorker {
	let remoteStore: INewPasswordRemoteStore
	let inMemoryStore: INewPasswordInMemoryStore
	
	init(remoteStore: INewPasswordRemoteStore,
		 inMemoryStore: INewPasswordInMemoryStore) {
		self.remoteStore = remoteStore
		self.inMemoryStore = inMemoryStore
	}
}

extension NewPasswordWorker: INewPasswordWorker {
}
