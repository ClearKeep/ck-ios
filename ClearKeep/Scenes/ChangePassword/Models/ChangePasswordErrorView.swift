//
//  ChangePasswordErrorView.swift
//  ClearKeep
//
//  Created by Quang Pham on 08/08/2022.
//

import Networking

enum ChangePasswordAlert: Error {
	case success
}

enum ChangePasswordErrorView {
	case wrongPassword
	case locked
	case success
	case unknownError(errorCode: Int?)

	// MARK: Init
	init(_ error: Error) {
		if let localError = error as? ChangePasswordAlert {
			switch localError {
			case .success:
				self = .success
			}
			return
		}
		guard let errorResponse = error as? IServerError else {
			self = .unknownError(errorCode: nil)
			return
		}

		let errorCode = errorResponse.status
		switch errorCode {
		case 1001, 1079:
			self = .wrongPassword
		case 1069:
			self = .locked
		default:
			self = .unknownError(errorCode: errorCode)
		}
	}

	// MARK: Content
	var title: String {
		switch self {
		case .wrongPassword:
			return "General.Error".localized
		case .locked:
			return "General.Error".localized
		case .success:
			return "NewPassword.Sucess.Title".localized
		default:
			return "General.Error".localized
		}
	}

	var message: String {
		switch self {
		case .wrongPassword:
			return "NewPassword.Error.Oldpasss".localized
		case .locked:
			return "Error.Authentication.Locked".localized
		case .success:
			return "NewPassword.Sucess".localized
		default:
			return "Error.Unknow.Message".localized
		}
	}

	var primaryButtonTitle: String {
		return "General.OK".localized
	}
}
