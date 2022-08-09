//
//  SocialCommonStyle.swift
//  ClearKeep
//
//  Created by đông on 18/03/2022.
//

import SwiftUI
import Common

protocol ISocialCommonStyle {
	var buttonBack: String { get }
	var title: String { get }
	var buttonNext: String { get }
	
	func nextView(userName: String, token: String, pinCode: String?, customServer: Binding<CustomServer>, dismiss: @escaping () -> Void) -> AnyView
}

enum SocialCommonStyle: ISocialCommonStyle {
	case setSecurity
	case confirmSecurity
	case confirmResetSecurity
	case verifySecurity
	case forgotPassface
	
	var buttonBack: String {
		switch self {
		case .setSecurity, .forgotPassface:
			return "Social.SetPhrase.Back".localized
		case .confirmSecurity, .confirmResetSecurity:
			return "Social.ConfirmPhrase.Back".localized
		case .verifySecurity:
			return "Social.Verify.Back".localized
		}
	}
	
	var title: String {
		switch self {
		case .setSecurity, .forgotPassface:
			return "Social.Title.Set".localized
		case .confirmSecurity, .confirmResetSecurity:
			return "Social.Title.Confirm".localized
		case .verifySecurity:
			return "Social.Title.Verify".localized
		}
	}
	
	var buttonNext: String {
		switch self {
		case .setSecurity, .forgotPassface:
			return "Social.Next".localized
		case .confirmSecurity, .confirmResetSecurity:
			return "Social.Next".localized
		case .verifySecurity:
			return "Social.Verify.Next".localized
		}
	}
	
	var textInput: String {
		switch self {
		case .setSecurity, .forgotPassface:
			return "Social.Security.Set".localized
		case .confirmSecurity, .confirmResetSecurity:
			return "Social.Security.Confirm".localized
		case .verifySecurity:
			return "Social.Input.Verify".localized
		}
	}
	
	var textInputDescription: String {
		switch self {
		case .setSecurity, .forgotPassface:
			return "Social.Security.Set.Description".localized
		default:
			return ""
		}
	}
	
	func nextView(userName: String, token: String, pinCode: String?, customServer: Binding<CustomServer>, dismiss: @escaping () -> Void) -> AnyView {
		switch self {
		case .setSecurity:
			return AnyView(SocialView(userName: userName, resetToken: token, pinCode: pinCode, socialStyle: .confirmSecurity, customServer: customServer, dismiss: dismiss))
		case .confirmSecurity, .confirmResetSecurity:
			return AnyView(SocialView(userName: userName, resetToken: token, pinCode: pinCode, socialStyle: .verifySecurity, customServer: customServer, dismiss: dismiss))
		case .verifySecurity:
			return AnyView(SocialView(userName: userName, resetToken: token, pinCode: pinCode, socialStyle: .verifySecurity, customServer: customServer, dismiss: dismiss))
		case .forgotPassface:
			return AnyView(SocialView(userName: userName, resetToken: token, pinCode: pinCode, socialStyle: .confirmResetSecurity, customServer: customServer, dismiss: dismiss))
		}
	}
}
