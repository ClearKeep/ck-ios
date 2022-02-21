//
//  APIService.swift
//  iOSBase
//
//  Created by NamNH on 05/10/2021.
//

import Networking

protocol IAPIService {
	func getSamples(completion: @escaping (Result<[ISampleModel], Error>) -> Void)
}

class APIService {
	public let client: INetworkingService
	public let query: IAPIResourceQueryAdapter
	public let resourceHandler: IAPIResourceResponseAdapter
	
	public init(client: INetworkingService,
				query: IAPIResourceQueryAdapter,
				resourceHandler: IAPIResourceResponseAdapter) {
		self.client = client
		self.query = query
		self.resourceHandler = resourceHandler
	}
}

// MARK: - IAPIService
extension APIService: IAPIService {
	func getSamples(completion: @escaping (Result<[ISampleModel], Error>) -> Void) {
		let request = query.getSamples()
		client.request(request, type: .data) { result in
			switch result {
			case .success(let data):
				self.resourceHandler.getSamples(data, completion: completion)
			case .failure(let error):
				guard let errorData = error.responseData else {
					completion(.failure(error))
					return
				}
				self.resourceHandler.handle(errorData: errorData) { serverError in
					completion(.failure(serverError ?? error))
				}
			}
		}
	}
}
