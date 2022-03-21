//
//  SocialWorker.swift
//  ClearKeep
//
//  Created by đông on 08/03/2022.
//

import UIKit
import Combine
import Common

protocol ISocialWorker {
	var remoteStore: ISocialRemoteStore { get }
	var inMemoryStore: ISocialInMemoryStore { get }
}

struct SocialWorker {
	let remoteStore: ISocialRemoteStore
	let inMemoryStore: ISocialInMemoryStore

	init(remoteStore: ISocialRemoteStore, inMemoryStore: ISocialInMemoryStore) {
		self.remoteStore = remoteStore
		self.inMemoryStore = inMemoryStore
	}
}

extension SocialWorker: ISocialWorker {
}
