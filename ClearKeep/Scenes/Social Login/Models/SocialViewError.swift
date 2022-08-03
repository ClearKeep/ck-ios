//
//  SocialViewError.swift
//  ClearKeep
//
//  Created by NamNH on 10/05/2022.
//

import Foundation
import Networking

enum SocialViewError {
	case unauthorized
	case unknownError(errorCode: Int?)
	
	// MARK: Init
	init(_ error: Error) {
		guard let errorResponse = error as? IServerError else {
			self = .unknownError(errorCode: nil)
			return
		}
		
		let errorCode = errorResponse.status
		switch errorCode {
		case 1079:
			self = .unauthorized
		default:
			self = .unknownError(errorCode: errorCode)
		}
	}
	
	// MARK: Content
	var title: String {
		return "General.Error".localized
	}
	
	var message: String {
		switch self {
		case .unauthorized:
			return "Social.Warning.Security".localized
		case .unknownError(let errorCode):
			if let errorCode = errorCode {
				return String(format: "Error.Unknow.Message".localized, errorCode)
			}
			return "Unknow.Message".localized
		}
	}
	
	var primaryButtonTitle: String {
		return "General.OK".localized
	}
}
