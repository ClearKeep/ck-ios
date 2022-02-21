//
//  INetworkConnectionHandler.swift
//  Networking
//
//  Created by NamNH on 02/10/2021.
//

import Foundation
import Common

protocol INetworkConnectionError: INetworkResponseError { }

enum NetworkConnectionError: INetworkConnectionError {
	case unavailable
	case timeOut
	
	init(from decoder: Decoder) throws {
		throw NetworkConnectionError.timeOut
	}
	
	var message: String? {
		switch self {
		case .unavailable:
			return "Network.Connection.Unavailable.Message".localized
		case .timeOut:
			return "Network.Connection.TimeOut.Message".localized
		}
	}
	
	var name: String? {
		switch self {
		case .unavailable:
			return "Network.Connection.Unavailable.Name".localized
		case .timeOut:
			return "Network.Connection.TimeOut.Name".localized
		}
	}
	
	var statusCode: Int? {
		return nil
	}
}

public protocol INetworkConnectionHandler {
	func waitUntilCheckNetworkConnectionCompleted(completion: @escaping (Result<Bool, Error>) -> Void)
}
