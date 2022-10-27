//
//  RegisterViewError.swift
//  ClearKeep
//
//  Created by NamNH on 06/05/2022.
//

import Foundation
import Networking

enum RegisterViewError {
	case existed
	case unknownError(errorCode: Int?)
	
	// MARK: Init
	init(_ error: Error) {
		guard let errorResponse = error as? IServerError else {
			self = .unknownError(errorCode: nil)
			return
		}
		
		let errorCode = errorResponse.status
		switch errorCode {
		case 1002:
			self = .existed
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
		case .existed:
			return "Error.Authentication.Existed".localized
		default:
			return "Error.Unknow.Message".localized
		}
	}
	
	var primaryButtonTitle: String {
		return "General.OK".localized
	}
}
