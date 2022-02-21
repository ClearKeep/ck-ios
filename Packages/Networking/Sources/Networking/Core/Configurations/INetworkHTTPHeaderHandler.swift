//
//  INetworkHTTPHeaderHandler.swift
//  Networking
//
//  Created by NamNH on 02/10/2021.
//

import Foundation

public protocol INetworkHTTPHeaderHandler {
	func construct(from request: URLRequest, configurations: INetworkConfigurations) -> [String: String]?
}
