//
//  FogotPasswordViewError.swift
//  ClearKeep
//
//  Created by MinhDev on 03/08/2022.
//

import Foundation
import Networking

enum FogotPasswordViewError {
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
		case 1005:
			self = .unauthorized
		default:
			self = .unknownError(errorCode: errorCode)
		}
	}

	// MARK: Content
	var title: String {
		switch self {
		case .unauthorized:
			return "General.Error".localized
		case .unknownError(let errorCode):
			if let errorCode = errorCode {
				return String(format: "Error.Unknow.Message".localized, errorCode)
			}
			return "Unknow.Message".localized
		}
	}

	var message: String {
		switch self {
		case .unauthorized:
			return "ForgotPassword.Error.FindAccount".localized
		case .unknownError(let errorCode):
			if let errorCode = errorCode {
				return String(format: "Error.Unknow.Message".localized, errorCode)
			}
			return "Unknow.Message".localized
		}
	}

	var primaryButtonTitle: String {
		return "General.Close".localized
	}
}
