//
//  NetworkConfigurations.swift
//  Networking
//
//  Created by NamNH on 02/10/2021.
//

import Foundation

public class NetworkConfigurations: INetworkConfigurations {
	public let cachePolicy: URLRequest.CachePolicy
	public let timeoutInterval: TimeInterval
	public let defaultHTTPHeaderFields: [String: String]
	
	public init(cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy,
				timeoutInterval: TimeInterval = 60,
				defaultHTTPHeaderFields: [String: String] = [:]) {
		self.cachePolicy = cachePolicy
		self.timeoutInterval = timeoutInterval
		self.defaultHTTPHeaderFields = defaultHTTPHeaderFields
	}
}
