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
}

struct HomeRemoteStore {
	let channelStorage: IChannelStorage
}

extension HomeRemoteStore: IHomeRemoteStore {
}
