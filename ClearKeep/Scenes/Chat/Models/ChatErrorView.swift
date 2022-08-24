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
	case downloadFail
}

enum ChatErrorView {
	case unauthorized
	case locked
	case fileLimit
	case fileSize
	case haveExistACall
	case permission
	case removed
	case downloadFail
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
			case .downloadFail:
				self = .downloadFail
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
		case .haveExistACall:
			return "General.Warning".localized
		case .fileLimit, .fileSize:
			return "Error.SendMessage.Title".localized
		case .permission:
			return "Call.PermistionCall".localized
		case .removed:
			return ""
		case .downloadFail:
			return "General.Error".localized
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
		case .downloadFail:
			return "Chat.Error.DownloadFail".localized
		}
	}

	var primaryButtonTitle: String {
		switch self {
		case .unauthorized, .locked, .haveExistACall, .permission, .removed, .downloadFail:
			return "General.OK".localized
		case .fileLimit, .fileSize:
			return "General.Close".localized
		case .unknownError(let errorCode):
			if let errorCode = errorCode {
				return String(format: "Error.Unknow.Message".localized, errorCode)
			}
			return "General.OK".localized
		}
	}
}
