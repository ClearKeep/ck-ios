//
//  HomeRemoteStore.swift
//  iOSBase-SwiftUI
//
//  Created by NamNH on 15/02/2022.
//

import Foundation
import Combine
import ChatSecure

protocol IHomeRemoteStore {
	func signOut()
}

struct HomeRemoteStore {
	let channelStorage: IChannelStorage
	let authenticationService: IAuthenticationService
}

extension HomeRemoteStore: IHomeRemoteStore {
	func signOut() {
	}
}
