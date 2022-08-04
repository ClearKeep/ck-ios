//
//  ProfileErrorView.swift
//  ClearKeep
//
//  Created by Quang Pham on 03/08/2022.
//

import Foundation
import Networking

enum ProfileError: Swift.Error {
	case socialAccount
	case emptyPhoneNumber
}

enum ProfileErrorView {
	case socialAccount
	case emptyPhoneNumber
	case unauthorized
	case locked
	case unknownError(errorCode: Int?)

	// MARK: Init
	init(_ error: Error) {
		if let localError = error as? ProfileError {
			switch localError {
			case .socialAccount:
				self = .socialAccount
			case .emptyPhoneNumber:
				self = .emptyPhoneNumber
			}
			return
		}
		
		guard let errorResponse = error as? IServerError else {
			self = .unknownError(errorCode: nil)
			return
		}

		let errorCode = errorResponse.status
		switch errorCode {
		case 1079:
			self = .unauthorized
		case 1069:
			self = .locked
		default:
			self = .unknownError(errorCode: errorCode)
		}
	}

	// MARK: Content
	var title: String {
		switch self {
		case .socialAccount:
			return "2FA.Not.Support".localized
		case .emptyPhoneNumber:
			return "2FA.Missing.Phone.Number".localized
		case .unauthorized:
			return "General.Error".localized
		case .locked:
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
		case .socialAccount:
			return "2FA.Not.Support.Error".localized
		case .emptyPhoneNumber:
			return "2FA.Missing.Phone.Number.Error".localized
		case .unauthorized:
			return "Error.Authentication.UnAuthorized".localized
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
