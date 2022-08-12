//
//  GroupDetailErrorView.swift
//  ClearKeep
//
//  Created by MinhDev on 12/08/2022.
//

import Foundation
import Networking

enum GroupDetailErrorView {
	case memberAdded
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
		case 1057:
			self = .memberAdded
		case 1077:
			self = .unauthorized
		default:
			self = .unknownError(errorCode: errorCode)
		}
	}

	// MARK: Content
	var title: String {
		switch self {
		case .memberAdded:
			return "General.Warning".localized
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
		case .memberAdded:
			return "Error.Authentication.UnAuthorized".localized
		case .unauthorized:
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
