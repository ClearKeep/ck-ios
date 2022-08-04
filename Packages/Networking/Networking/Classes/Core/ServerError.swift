//
//  ServerError.swift
//  Networking
//
//  Created by NamNH on 31/03/2022.
//

import Foundation
import Common
import GRPC

public protocol IServerError: Error, Decodable {
	var message: String? { get }
	var name: String? { get }
	var status: Int? { get }
}

public struct ServerError: IServerError {
	public let message: String?
	public let name: String?
	public let status: Int?
	
	public static var unknown: IServerError {
		ServerError(message: "Unknow.Message".localized, name: "Unknow.Message".localized, status: nil)
	}
	
	public static var cancel: IServerError {
		ServerError(message: nil, name: nil, status: nil)
	}
	
	public init(message: String?, name: String?, status: Int?) {
		self.message = message
		self.name = name
		self.status = status
	}
	
	public init(_ error: Error?) {
		if let serverError = error as? IServerError {
			self.init(message: serverError.message, name: serverError.name, status: serverError.status)
		} else if let grpcError = error as? GRPCStatus {
			let errorMessagesData = grpcError.message?.data(using: .utf8, allowLossyConversion: false) ?? Data()
			let errorMessages = try? JSONSerialization.jsonObject(with: errorMessagesData, options: .allowFragments) as? [[String: Any]]
			let errorMessage = errorMessages?.first?["message"] as? String
			let errorCode = errorMessages?.first?["code"] as? Int
			self.init(message: errorMessage, name: grpcError.code.description, status: errorCode)
		} else {
			self.init(message: "Unknow.Message".localized, name: "Unknow.Message".localized, status: nil)
		}
	}
}
