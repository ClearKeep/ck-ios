//
//  NetworkResponseError.swift
//  Networking
//
//  Created by NamNH on 02/10/2021.
//

import Foundation

public struct NetworkResponseError: INetworkResponseError {
	public let message: String?
	public let name: String?
	public let statusCode: Int?
	
	public init(message: String?, name: String?, statusCode: Int?) {
		self.message = message
		self.name = name
		self.statusCode = statusCode
	}
}

public extension Error {
	var responseData: Data? {
		if let nsError = self as NSError? {
			let responseData = nsError.userInfo["responseData"] as? Data
			return responseData
		} else {
			return nil
		}
	}
	
	func isUnauthorized() -> Bool {
		let nsError = self as NSError
		if nsError.code == 401 {
			return true
		} else {
			return false
		}
	}
}
