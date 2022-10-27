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
	case avatarSize
}

enum ProfileErrorView {
	case socialAccount
	case emptyPhoneNumber
	case unauthorized
	case locked
	case avatarSize
	case unknownError(errorCode: Int?)

	// MARK: Init
	init(_ error: Error) {
		if let localError = error as? ProfileError {
			switch localError {
			case .socialAccount:
				self = .socialAccount
			case .emptyPhoneNumber:
				self = .emptyPhoneNumber
			case .avatarSize:
				self = .avatarSize
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
		case .avatarSize:
			return "General.Warning".localized
		case .unauthorized:
			return "General.Error".localized
		case .locked:
			return "General.Error".localized
		default:
			return "General.Error".localized
		}
	}

	var message: String {
		switch self {
		case .socialAccount:
			return "2FA.Not.Support.Error".localized
		case .emptyPhoneNumber:
			return "2FA.Missing.Phone.Number.Error".localized
		case .avatarSize:
			return "UserProfile.Avatar.Size.Warning".localized
		case .unauthorized:
			return "Error.Authentication.UnAuthorized".localized
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
