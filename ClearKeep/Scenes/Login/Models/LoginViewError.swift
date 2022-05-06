//
//  LoginViewError.swift
//  ClearKeep
//
//  Created by NamNH on 05/05/2022.
//

import UIKit
import Networking

enum LoginViewError {
	case unauthorized
	case notActivated
	case locked
	case unknownError(errorCode: Int?)
	
	// MARK: Init
	init(_ error: Error) {
		guard let errorResponse = error as? IServerError else {
			self = .unknownError(errorCode: nil)
			return
		}
		
		let errorCode = errorResponse.status
		switch errorCode {
		case 1001, 1079:
			self = .unauthorized
		case 1026:
			self = .notActivated
		case 1069:
			self = .locked
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
			return "Error.Authentication.UnAuthorized".localized
		case .notActivated:
			return "Error.Authentication.NotActivated".localized
		case .locked:
			return "Error.Authentication.Locked".localized
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
