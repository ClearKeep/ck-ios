//
//  NetworkConnectionHandler.swift
//  Networking
//
//  Created by NamNH on 02/10/2021.
//

import Foundation

public class NetworkConnectionHandler: INetworkConnectionHandler {
	public init() {}
	
	public func waitUntilCheckNetworkConnectionCompleted(completion: @escaping (Result<Bool, Error>) -> Void) {
		isNetworkAvailable() ? completion(.success(true)): completion(.failure(NetworkConnectionError.unavailable))
	}
}

// MARK: - Private
private extension NetworkConnectionHandler {
	func isNetworkAvailable() -> Bool {
		let reachability = try? Reachability()
		
		switch reachability?.connection {
		case .cellular, .wifi:
			return true
		case .unavailable:
			return false
		case .none?:
			return false
		case nil:
			return false
		}
	}
}
