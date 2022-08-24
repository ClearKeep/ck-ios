//
//  ChatErrorView.swift
//  ClearKeep
//
//  Created by Quang Pham on 18/08/2022.
//

import Networking

enum ChatError: Error {
	case fileLimit
	case fileSize
	case haveExistACall
	case permission
	case removed
}

enum ChatErrorView {
	case unauthorized
	case locked
	case fileLimit
	case fileSize
	case haveExistACall
	case permission
	case removed
	case unknownError(errorCode: Int?)

	// MARK: Init
	init(_ error: Error) {
		if let localError = error as? ChatError {
			switch localError {
			case .fileLimit:
				self = .fileLimit
			case .fileSize:
				self = .fileSize
			case .haveExistACall:
				self = .haveExistACall
			case .permission:
				self = .permission
		case .removed:
			self = .removed
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
		case .unauthorized:
			return "General.Error".localized
		case .locked:
			return "General.Error".localized
		case .unknownError(let errorCode):
			if let errorCode = errorCode {
				return String(format: "Error.Unknow.Message".localized, errorCode)
			}
			return "Unknow.Message".localized
		case .fileLimit, .fileSize, .haveExistACall:
			return "General.Warning".localized
		case .permission:
			return "Call.PermistionCall".localized
		case .removed:
			return ""
		}

	}

	var message: String {
		switch self {
		case .unauthorized:
			return "Error.Authentication.UnAuthorized".localized
		case .locked:
			return "Error.Authentication.Locked".localized
		case .unknownError(let errorCode):
			if let errorCode = errorCode {
				return String(format: "Error.Unknow.Message".localized, errorCode)
			}
			return "Unknow.Message".localized
		case .fileLimit:
			return "Chat.Error.FileLimit".localized
		case .fileSize:
			return "Chat.Error.FileSizeLimit".localized
		case .haveExistACall:
			return "Call.HaveExistCall".localized
		case .permission:
			return "Call.GoToSetting".localized
		case .removed :
			return "Chat.Error.Removed".localized
		}
	}

	var primaryButtonTitle: String {
		return "General.OK".localized
	}
}
