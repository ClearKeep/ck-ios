//
//  ChannelStorage.swift
//  ChatSecure
//
//  Created by NamNH on 16/03/2022.
//

import Foundation

class ChannelStorage {
	static let shared = ChannelStorage()
	
	private var channels: [String: APIService]
	
	private init() {
		channels = [Constants.clkDomain: APIService(domain: Constants.clkDomain)]
	}
	
	func getChannels(domain: String) -> APIService {
		if channels.contains(where: { $0.key == domain }) {
			return channels[domain] ?? APIService(domain: domain)
		} else {
			let channel = APIService(domain: domain)
			channels[domain] = channel
			return channels[domain] ?? APIService(domain: domain)
		}
	}
}
