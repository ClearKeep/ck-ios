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
	func registerToken(_ token: String)
	func subscribeAndListenServers()
	func updateServerToken(token: ITokenModel, domain: String)
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
	private var servers: [RealmServer] = []
	private let clientStore: ClientStore
	
	public init(config: IChatSecureConfig, clientStore: ClientStore, realmManager: RealmManager) {
		self.config = config
		self.clientStore = clientStore
		self.realmManager = realmManager
		channels = [config.clkDomain + ":" + config.clkPort: APIService(domain: config.clkDomain + ":" + config.clkPort)]
	}
	
	public func getServers() -> [RealmServer] {
		servers = realmManager.getServers()
		servers.forEach { server in
			getChannel(domain: server.serverDomain).updateHeaders(accessKey: server.accessKey, hashKey: server.hashKey)
		}
		return servers
	}
	
	public func didSelectServer(_ domain: String?) -> [RealmServer] {
		return realmManager.activeServer(domain: domain)
	}
	
	public func registerToken(_ token: String) {
		servers.forEach { server in
			let notificationService = NotificationService(clientStore: clientStore)
			notificationService.registerToken(token, domain: server.serverDomain)
		}
	}
	
	public func subscribeAndListenServers() {
		self.servers.forEach { server in
			let subscribeAndListenService = SubscribeAndListenService(clientStore: self.clientStore)
			subscribeAndListenService.subscribe(server.serverDomain)
		}
	}
	
	public func updateServerToken(token: ITokenModel, domain: String) {
		realmManager.updateServerToken(token: token, domain: domain)
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
