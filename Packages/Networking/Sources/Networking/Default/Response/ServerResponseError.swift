//
//  ServerResponseError.swift
//  Networking
//
//  Created by NamNH on 02/11/2021.
//

import Foundation

public protocol IServerResponseError: Error, Decodable {
	var message: String? { get }
	var name: String? { get }
	var status: Int? { get }
}

public struct ServerResponseError: IServerResponseError {
	public let message: String?
	public let name: String?
	public let status: Int?
	
	public init(message: String?, name: String?, status: Int?) {
		self.message = message
		self.name = name
		self.status = status
	}
	
	public init(_ error: Error?) {
		if let serverError = error as? IServerResponseError {
			self.init(message: serverError.message, name: serverError.name, status: serverError.status)
		} else {
			let jsonObject = try? JSONSerialization.jsonObject(with: error?.responseData ?? Data(), options: .allowFragments) as? [String: Any]
			let errorObject = jsonObject?["error"] as? [String: Any]
			let errorCode = errorObject?["code"] as? Int
			self.init(message: "Unknow message", name: nil, status: errorCode)
		}
	}
}
