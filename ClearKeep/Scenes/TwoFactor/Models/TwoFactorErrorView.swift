//
//  TwoFactorErrorView.swift
//  ClearKeep
//
//  Created by Quang Pham on 02/08/2022.
//

import Foundation
import Networking

enum TwoFactorError: Swift.Error {
	case invalidPassword
}

enum TwoFactorErrorView {
	case invalidPassword
	case unauthorized
	case wrongOTP
	case locked
	case expiredOTP
	case unknownError(errorCode: Int?)
	
	// MARK: Init
	init(_ error: Error) {
		if let localError = error as? TwoFactorError {
			switch localError {
			case .invalidPassword:
				self = .invalidPassword
			}
			return
		}
		guard let errorResponse = error as? IServerError else {
			self = .unknownError(errorCode: nil)
			return
		}
		let errorCode = errorResponse.status
		switch errorCode {
		case 1071:
			self = .wrongOTP
		case 1079:
			self = .unauthorized
		case 1069:
			self = .locked
		case 1068, 1072:
			self = .expiredOTP
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
		case .wrongOTP:
			return "2FA.Authentication.Fail.Error".localized
		case .invalidPassword:
			return "General.Password.Valid".localized
		case .unauthorized:
			return "2FA.Error.PasswordInCorrect".localized
		case .locked:
			return "Error.Authentication.Locked".localized
		case .unknownError(let errorCode):
			if let errorCode = errorCode {
				return String(format: "Error.Unknow.Message".localized, errorCode)
			}
			return "Unknow.Message".localized
		case .expiredOTP:
			return "2FA.Error.Pincode.RequestTimeout".localized
		}
	}
	
	var primaryButtonTitle: String {
		switch self {
		case .invalidPassword:
			return "General.OK".localized
		case .unauthorized:
			return "General.Close".localized
		case .wrongOTP:
			return "General.OK".localized
		case .locked:
			return "General.OK".localized
		case .unknownError(let errorCode):
			return "General.OK".localized
		case .expiredOTP:
			return "General.OK".localized
		}
	}
}
