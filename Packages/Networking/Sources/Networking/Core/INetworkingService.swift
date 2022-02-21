//
//  INetworkingService.swift
//  Networking
//
//  Created by NamNH on 30/09/2021.
//

import Foundation

public protocol INetworkingService {
	func request(_ request: URLRequest, type: NetworkRequestType, completion: @escaping (Result<Data?, Error>) -> Void)
	func cancelAllRequests()
	func cancel(_ request: URLRequest)
}
