//
//  NetworkService.swift
//  Networking
//
//  Created by NamNH on 02/10/2021.
//

import Foundation
import Alamofire

public class NetworkingService {
	let configurations: INetworkConfigurations
	let httpHeaderHandler: INetworkHTTPHeaderHandler?
	let responseHandler: INetworkHTTPResponseHandler?
	let networkConnectionHandler: INetworkConnectionHandler
	
	public init(configurations: INetworkConfigurations,
				  httpHeaderHandler: INetworkHTTPHeaderHandler? = nil,
				  responseHandler: INetworkHTTPResponseHandler? = nil,
				  networkConnectionHandler: INetworkConnectionHandler) {
		self.configurations = configurations
		self.httpHeaderHandler = httpHeaderHandler
		self.responseHandler = responseHandler
		self.networkConnectionHandler = networkConnectionHandler
	}
}

extension NetworkingService: INetworkingService {
	public func request(_ request: URLRequest, type: NetworkRequestType, completion: @escaping (Result<Data?, Error>) -> Void) {
		networkConnectionHandler.waitUntilCheckNetworkConnectionCompleted { result in
			switch result {
			case .success:
				self.performFetch(request, type: type, completion: completion)
			case .failure(let error):
				completion(.failure(error))
			}
		}
	}
	
	public func cancelAllRequests() {
		AF.cancelAllRequests()
	}
	
	public func cancel(_ request: URLRequest) {
		AF.session.getTasksWithCompletionHandler { dataTasks, uploadTasks, downloadTaks in
			dataTasks.forEach({
				if $0.originalRequest?.urlRequest == request {
					$0.cancel()
				}
			})
			
			uploadTasks.forEach({
				if $0.originalRequest?.urlRequest == request {
					$0.cancel()
				}
			})
			
			downloadTaks.forEach({
				if $0.originalRequest?.urlRequest == request {
					$0.cancel()
				}
			})
		}
	}
}

private extension NetworkingService {
	func performFetch(_ request: URLRequest, type: NetworkRequestType, completion: @escaping (Result<Data?, Error>) -> Void) {
		var customRequest = request
		customRequest.cachePolicy = configurations.cachePolicy
		customRequest.allHTTPHeaderFields = httpHeaderHandler?.construct(
			from: request,
			configurations: configurations)
		
		switch type {
		case .data:
			AF.request(request).responseData { response in
				self.responseHandler?.handle(response: response, completion: completion)
			}
		case .upload(let multipartForm):
			AF.upload(multipartFormData: multipartForm, with: request).responseData { response in
				self.responseHandler?.handle(response: response, completion: completion)
			}
		case .download:
			AF.download(request).responseData { response in
				// TODO: - Handle download
				print(response)
			}
		}
	}
}
