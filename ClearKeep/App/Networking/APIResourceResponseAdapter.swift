//
//  APIResourceResponseAdapter.swift
//  iOSBase
//
//  Created by NamNH on 05/10/2021.
//

import Foundation
import Networking

protocol IAPIResourceResponseAdapter: INetworkErrorResponseHandler {
	func getSamples(_ data: Data?, completion: (Result<[ISampleModel], Error>) -> Void)
}

struct APIResourceResponseAdapter {
	var jsonHandler: JSONDataHandler
	
	func handle(errorData: Data?, completion: @escaping (INetworkResponseError?) -> Void) {
		jsonHandler.handle(jsonData: errorData) { (result: Result<ServerErrorResponse, Error>) in
			switch result {
			case .success(let serverError):
				let serverError = NetworkResponseError(message: serverError.message, name: serverError.name, statusCode: serverError.statusCode)
				completion(serverError)
			case .failure(let error):
				let serverError = NetworkResponseError(message: error.localizedDescription, name: "", statusCode: nil)
				completion(serverError)
			}
		}
	}
}

// MARK: - IAPIResourceResponseAdapter
extension APIResourceResponseAdapter: IAPIResourceResponseAdapter {
	func getSamples(_ data: Data?, completion: (Result<[ISampleModel], Error>) -> Void) {
		jsonHandler.handle(jsonData: data) { (result: Result<SampleResponse, Error>) in
			switch result {
			case .success(let samples):
				let sampleModels = samples.data?.compactMap({
					SampleModel(item: $0)
				})
				completion(.success(sampleModels ?? []))
			case .failure(let error):
				completion(.failure(error))
			}
		}
	}
}
