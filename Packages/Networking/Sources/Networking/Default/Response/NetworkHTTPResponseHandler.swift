//
//  NetworkHTTPResponseHandler.swift
//  Networking
//
//  Created by NamNH on 02/10/2021.
//

import Foundation
import Alamofire

public struct NetworkHTTPResponseHandler {
	public init() { }
}

// MARK: - INetworkHTTPResponseHandler

extension NetworkHTTPResponseHandler: INetworkHTTPResponseHandler {
	public func handle(response: AFDataResponse<Data>, completion: @escaping (Result<Data?, Error>) -> Void) {
		guard let httpResponse = response.response else {
			if let errorResponse = response.error as NSError? {
				if errorResponse.code == NSURLErrorTimedOut {
					completion(.failure(NetworkConnectionError.timeOut))
				}
				completion(.failure(errorResponse))
			}
			return
		}
		
		switch httpResponse.statusCode {
		case 200..<399:
			completion(.success(response.data))
			
		default:
			let responseError = NetworkResponseErrorBuilder.build(
				data: response.data,
				response: httpResponse,
				error: response.error)
			
			completion(.failure(responseError))
		}
	}
}
