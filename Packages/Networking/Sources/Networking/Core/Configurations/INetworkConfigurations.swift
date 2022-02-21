//
//  INetworkConfigurations.swift
//  Networking
//
//  Created by NamNH on 02/10/2021.
//

import Foundation

public protocol INetworkConfigurations {
	var cachePolicy: URLRequest.CachePolicy { get }
	var timeoutInterval: TimeInterval { get }
	var defaultHTTPHeaderFields: [String: String] { get }
}
