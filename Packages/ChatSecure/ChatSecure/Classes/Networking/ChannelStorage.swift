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
	var servers: [RealmServer] { get }
	
	func getServers(isFirstLoad: Bool) -> [RealmServer]
	@discardableResult
	func didSelectServer(_ domain: String?) -> [RealmServer]
	func registerToken(_ token: String)
	func removeServer(_ domain: String)
	func removeGroup(_ domain: String)
	func removeUser(_ server: RealmServer)
	func removeProfile(_ profileId: String)
	func updateServerUser(displayName: String, avatar: String, phoneNumber: String, domain: String)
	func getSenderName(fromClientId: String, groupId: Int64, domain: String, ownerId: String) -> String
	func getGroupName(groupId: Int64, domain: String, ownerId: String) -> String
	func getServerWithClientId(clientId: String) -> RealmServer?
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
	public var servers: [RealmServer] = []
	private let clientStore: ClientStore

	public init(config: IChatSecureConfig, clientStore: ClientStore, realmManager: RealmManager) {
		self.config = config
		self.clientStore = clientStore
		self.realmManager = realmManager
		self.channels = [config.clkDomain + ":" + config.clkPort: APIService(domain: config.clkDomain + ":" + config.clkPort,
																			 owner: realmManager.getOwnerServer(domain: config.clkDomain + ":" + config.clkPort))]
	}

	public func getServers(isFirstLoad: Bool) -> [RealmServer] {
		servers = realmManager.getServers().detached
		if isFirstLoad {
			servers.forEach { server in
				getChannel(domain: server.serverDomain).updateHeaders(accessKey: server.accessKey, hashKey: server.hashKey)
			}
		}
		return servers
	}
	
	@discardableResult
	public func didSelectServer(_ domain: String?) -> [RealmServer] {
		return realmManager.activeServer(domain: domain)
	}

	public func removeServer(_ domain: String) {
		realmManager.removeServer(domain: domain)
	}
	
	public func removeGroup(_ domain: String) {
		realmManager.removeGroups(domain: domain)
	}
	
	public func removeUser(_ server: RealmServer) {
		realmManager.removeMember(server: server)
	}
	
	public func removeProfile(_ profileId: String) {
		realmManager.removeProfile(userId: profileId)
	}

	public func registerToken(_ token: String) {
		servers.forEach { server in
			let notificationService = NotificationService(clientStore: clientStore)
			notificationService.registerToken(token, domain: server.serverDomain)
		}
	}
	
	public func updateServerUser(displayName: String, avatar: String, phoneNumber: String, domain: String) {
		realmManager.updateServerUser(displayName: displayName, avatar: avatar, phoneNumber: phoneNumber, domain: domain)
	}
	
	public func getSenderName(fromClientId: String, groupId: Int64, domain: String, ownerId: String) -> String {
		return realmManager.getSenderName(fromClientId: fromClientId, groupId: groupId, domain: domain, ownerId: ownerId)
	}
	
	public func getGroupName(groupId: Int64, domain: String, ownerId: String) -> String {
		return realmManager.getGroupName(by: groupId, domain: domain, ownerId: ownerId)
	}
	
	public func getServerWithClientId(clientId: String) -> RealmServer? {
		return realmManager.getServerWithClientId(clientId: clientId)?.detached()
	}
}

// MARK: - Internal
extension ChannelStorage {
	func getChannel(domain: String, accessToken: String? = nil, hashKey: String? = nil) -> APIService {
		if channels.contains(where: { $0.key == domain }) {
			let channel = channels[domain]
			if accessToken != nil {
				channel?.updateHeaders(accessKey: accessToken, hashKey: hashKey)
			}
			return channel ?? APIService(domain: domain, owner: realmManager.getOwnerServer(domain: domain))
		} else if domain.isEmpty {
			return channels[config.clkDomain + ":" + config.clkPort] ?? APIService(domain: config.clkDomain + ":" + config.clkPort, owner: realmManager.getOwnerServer(domain: config.clkDomain + ":" + config.clkPort))
		} else {
			let channel = APIService(domain: domain, owner: realmManager.getOwnerServer(domain: domain))
			if accessToken != nil {
				channel.updateHeaders(accessKey: accessToken, hashKey: hashKey)
			}
			channels[domain] = channel
			return channels[domain] ?? APIService(domain: domain, owner: realmManager.getOwnerServer(domain: domain))
		}
	}
}
