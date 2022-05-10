//
//  HomeWorker.swift
//  iOSBase-SwiftUI
//
//  Created by NamNH on 15/02/2022.
//

import UIKit
import Combine
import Common
import ChatSecure

protocol IHomeWorker {
	var remoteStore: IHomeRemoteStore { get }
	var inMemoryStore: IHomeInMemoryStore { get }
	
	func getJoinedGroup() async
	func signOut() async
}

struct HomeWorker {
	let channelStorage: IChannelStorage
	let remoteStore: IHomeRemoteStore
	let inMemoryStore: IHomeInMemoryStore
	
	init(channelStorage: IChannelStorage, remoteStore: IHomeRemoteStore, inMemoryStore: IHomeInMemoryStore) {
		self.channelStorage = channelStorage
		self.remoteStore = remoteStore
		self.inMemoryStore = inMemoryStore
	}
}

extension HomeWorker: IHomeWorker {
	var currentDomain: String {
		channelStorage.currentChannel.domain
	}
	
	func getJoinedGroup() async {
		await remoteStore.getJoinedGroup(domain: currentDomain)
	}
	
	func signOut() async {
		await remoteStore.signOut()
	}
}
