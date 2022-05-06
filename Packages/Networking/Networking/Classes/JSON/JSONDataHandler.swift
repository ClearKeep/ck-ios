//
//  JSONDataHandler.swift
//  Networking
//
//  Created by NamNH on 30/09/2021.
//

import Foundation

public enum JSONDataHandlerError: Error {
	case emptyResponse
	case serialization(responseError: Error)
}

public struct JSONDataHandler: INetworkingServiceDataHandler {
	public init() {}
	
	public func handle<T: Decodable>(jsonData: Data?, completion: (Result<T, Error>) -> Void) {
		guard let data = jsonData else {
			completion(.failure(JSONDataHandlerError.emptyResponse))
			return
		}
		
		do {
			let decoder = JSONDecoder()
			let result = try decoder.decode(T.self, from: data)
			completion(.success(result))
			
		} catch {
			completion(.failure(JSONDataHandlerError.serialization(responseError: error)))
		}
	}
}
