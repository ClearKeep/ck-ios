//
//  ChannelStorage.swift
//  ChatSecure
//
//  Created by NamNH on 16/03/2022.
//

import Foundation

public protocol IChannelStorage {
	var channels: [String: APIService] { get }
	var config: IChatSecureConfig { get }
}

public class ChannelStorage: IChannelStorage {
	public var channels: [String: APIService]
	public let config: IChatSecureConfig
	
	public init(config: IChatSecureConfig) {
		self.config = config
		channels = [config.clkDomain + config.clkPort: APIService(domain: config.clkDomain + config.clkPort)]
	}
	
	public func getChannels(domain: String) -> APIService {
		if channels.contains(where: { $0.key == domain }) {
			return channels[domain] ?? APIService(domain: domain)
		} else if domain.isEmpty {
			return channels[config.clkDomain + config.clkPort]  ?? APIService(domain: config.clkDomain + config.clkPort)
		} else {
			let channel = APIService(domain: domain)
			channels[domain] = channel
			return channels[domain] ?? APIService(domain: domain)
		}
	}
}
