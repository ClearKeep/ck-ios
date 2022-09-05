//
//  HomeErrorView.swift
//  ClearKeep
//
//  Created by MinhDev on 18/08/2022.
//

import Foundation
import Networking

enum HomeErrorView {
	case domainUsed
	case existed
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
		case 1066:
			self = .existed
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
		return "AdvancedServer.Title.Error".localized
	}

	var message: String {
		switch self {
		case .domainUsed:
			return "AdvancedServer.Message.Error.DomainUsed".localized
		case .existed:
			return "AdvancedServer.Message.Error".localized
		case .wrongInformation:
			return "Login.Popup.Email.Password.Validate".localized
		case .unauthorized:
			return "General.Error".localized
		case .notActivated:
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

	var primaryButtonTitle: String {
		return "General.Close".localized
	}
}
