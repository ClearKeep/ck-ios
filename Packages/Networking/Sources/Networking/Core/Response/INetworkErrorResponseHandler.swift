//
//  NetworkErrorResponseHandler.swift
//  Networking
//
//  Created by NamNH on 30/09/2021.
//

import Foundation

public protocol INetworkResponseError: Error {
	var message: String? { get }
	var name: String? { get }
	var statusCode: Int? { get }
}

public protocol INetworkErrorResponseHandler {
	func handle(errorData: Data?, completion: @escaping (INetworkResponseError?) -> Void)
}
