//
//  ChannelStorage.swift
//  ChatSecure
//
//  Created by NamNH on 16/03/2022.
//

import Foundation
import Networking

public protocol IChannelStorage {
	var currentChannel: APIService { get }
	var channels: [String: APIService] { get }
	var config: IChatSecureConfig { get }
}

public class ChannelStorage: IChannelStorage {
	public var currentChannel: APIService
	public var channels: [String: APIService]
	public let config: IChatSecureConfig
	let serverStore: ServerStore = ServerStore()
	
	public init(config: IChatSecureConfig) {
		self.config = config
		channels = [config.clkDomain + ":" + config.clkPort: APIService(domain: config.clkDomain + ":" + config.clkPort)]
		currentChannel = channels.first?.value ?? APIService(domain: config.clkDomain + ":" + config.clkPort)
	}
	
	public func getChannel(domain: String, accessToken: String? = nil, hashKey: String? = nil) -> APIService {
		if channels.contains(where: { $0.key == domain }) {
			let channel = channels[domain]
			channel?.updateHeaders(accessKey: accessToken, hashKey: hashKey)
			return channel ?? APIService(domain: domain)
		} else if domain.isEmpty {
			return channels[config.clkDomain + ":" + config.clkPort] ?? APIService(domain: config.clkDomain + ":" + config.clkPort)
		} else {
			let channel = APIService(domain: domain)
			channel.updateHeaders(accessKey: accessToken, hashKey: hashKey)
			channels[domain] = channel
			return channels[domain] ?? APIService(domain: domain)
		}
	}
	
	public func updateChannel(domain: String) {
		guard let server = serverStore.getServer(by: domain) else { return }
		getChannel(domain: server.serverDomain).updateHeaders(accessKey: server.accessKey, hashKey: server.hashKey)
	}
}
