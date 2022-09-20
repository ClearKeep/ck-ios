//
//  AdvancedServerErrorView.swift
//  ClearKeep
//
//  Created by MinhDev on 03/08/2022.
//

import Foundation
import Networking

enum AdvancedServerErrorView {
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
		case 1066:
			self = .existed
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
		case .existed:
			return "AdvancedServer.Message.Error".localized
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
