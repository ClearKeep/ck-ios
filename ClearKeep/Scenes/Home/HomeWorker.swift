//
//  HomeWorker.swift
//  iOSBase-SwiftUI
//
//  Created by NamNH on 15/02/2022.
//

import UIKit
import Combine
import Common

protocol IHomeWorker {
	var remoteStore: IHomeRemoteStore { get }
	var inMemoryStore: IHomeInMemoryStore { get }
	
	func signOut()
}

struct HomeWorker {
	let remoteStore: IHomeRemoteStore
	let inMemoryStore: IHomeInMemoryStore
	
	init(remoteStore: IHomeRemoteStore, inMemoryStore: IHomeInMemoryStore) {
		self.remoteStore = remoteStore
		self.inMemoryStore = inMemoryStore
	}
}

extension HomeWorker: IHomeWorker {
	func signOut() {
		remoteStore.signOut()
	}
}
