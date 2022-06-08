//
//  ChannelStorage.swift
//  ChatSecure
//
//  Created by NamNH on 16/03/2022.
//

import Foundation
import Networking
import Model

public protocol IChannelStorage {
	var config: IChatSecureConfig { get }
	var channels: [String: APIService] { get }
	var currentServer: RealmServer? { get }
	var currentDomain: String { get }

	func getServers() -> [RealmServer]
	func didSelectServer(_ domain: String?) -> [RealmServer]
}

public class ChannelStorage: IChannelStorage {
	public let config: IChatSecureConfig
	public var channels: [String: APIService]
	public var currentServer: RealmServer? {
		return realmManager.getCurrentServer()
	}
	public var currentDomain: String {
		currentServer?.serverDomain ?? config.clkDomain + ":" + config.clkPort
	}

	let realmManager: RealmManager
	
	public init(config: IChatSecureConfig) {
		self.config = config
		realmManager = RealmManager(databasePath: config.databaseURL)
		channels = [config.clkDomain + ":" + config.clkPort: APIService(domain: config.clkDomain + ":" + config.clkPort)]
	}
	
	public func getServers() -> [RealmServer] {
		let servers = realmManager.getServers()
		servers.forEach { server in
			getChannel(domain: server.serverDomain).updateHeaders(accessKey: server.accessKey, hashKey: server.hashKey)
		}
		return servers
	}
	
	public func didSelectServer(_ domain: String?) -> [RealmServer] {
		return realmManager.activeServer(domain: domain)
	}
}

// MARK: - Internal
extension ChannelStorage {
	func getChannel(domain: String, accessToken: String? = nil, hashKey: String? = nil) -> APIService {
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
}
