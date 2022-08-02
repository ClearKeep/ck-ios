//
//  LoginViewPopUp.swift
//  ClearKeep
//
//  Created by MinhDev on 01/08/2022.
//

import Foundation
import Networking

enum LoginViewPopUp {

	case invalid
	case invalidEmail
	case emailblank
	case passwordBlank

	// MARK: Content
	var title: String {
		switch self {
		case.invalid:
			return "Login.Popup.Email.password.Validate".localized
		case .invalidEmail:
			return "Login.Popup.EmailValid".localized
		case .emailblank:
			return "Login.Popup.EmailBlank".localized
		case .passwordBlank:
			return "Login.Popup.PassBlank".localized
		}
	}

	var message: String {
		switch self {
		case.invalid:
			return "Login.Popup.Message".localized
		case .invalidEmail:
			return "Login.Popup.Message".localized
		case .emailblank:
			return "Login.Popup.Message".localized
		case .passwordBlank:
			return "Login.Popup.Message".localized
		}
	}

	var primaryButtonTitle: String {
		return "General.OK".localized
	}
}
