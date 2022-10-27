//
//  LoginViewError.swift
//  ClearKeep
//
//  Created by NamNH on 05/05/2022.
//

import Foundation
import Networking

enum LoginViewError {
	case wrongInformation
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
		case 1001:
			self = .wrongInformation
		case 1079, 1077:
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
		switch self {
		case .wrongInformation:
			return "Login.Popup.Email.Password.Validate".localized
		case .unauthorized:
			return "General.Error".localized
		case .notActivated:
			return "General.Error".localized
		case .locked:
			return "General.Error".localized
		default:
			return "General.Error".localized
		}
	}

	var message: String {
		switch self {
		case .wrongInformation:
			return "Error.Authentication.UnAuthorized".localized
		case .unauthorized:
			return "Error.Authentication.UnAuthorized".localized
		case .notActivated:
			return "Error.Authentication.NotActivated".localized
		case .locked:
			return "Error.Authentication.Locked".localized
		default:
			return "Error.Unknow.Message".localized
		}
	}

	var primaryButtonTitle: String {
		return "General.OK".localized
	}
}
