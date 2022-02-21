//
//  APIServiceError.swift
//  epic_medical_ios
//
//  Created by NamNH on 02/11/2021.
//

import Foundation
import Networking

enum APIServiceError: IServerResponseError {
	case unauthorized
	case serverError
	case unknownError(String?)
	
	enum ErrorStatusCode: Int {
		case unauthorized = 401
		case serverError = 500
	}
	
	init(_ errorResponse: ServerErrorResponse) {
		switch errorResponse.statusCode {
		case 401:
			self = .unauthorized
		case 500:
			self = .serverError
		default:
			self = .unknownError("")
		}
	}
	
	init(from decoder: Decoder) throws {
		throw APIServiceError.unknownError("decoder")
	}
	
	var message: String? {
		switch self {
		case .unauthorized:
			return "Unauthorized".localized
		case .serverError:
			return "ServerError".localized
		default:
			return "Unknow message".localized
		}
	}
	
	var name: String? {
		switch self {
		case .unauthorized:
			return "Error"
		case .serverError:
			return "Error"
		default:
			return "Error"
		}
	}
	
	var status: Int? {
		switch self {
		case .unauthorized:
			return ErrorStatusCode.unauthorized.rawValue
		case .serverError:
			return ErrorStatusCode.serverError.rawValue
		default:
			return nil
		}
	}
}
