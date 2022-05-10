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
	
	func nextView(userName: String, customServer: Binding<CustomServer>) -> AnyView
}

enum SocialCommonStyle: ISocialCommonStyle {
	case setSecurity
	case confirmSecurity
	case verifySecurity
	
	var buttonBack: String {
		switch self {
		case .setSecurity:
			return "Social.SetPhrase.Back".localized
		case .confirmSecurity:
			return "Social.ConfirmPhrase.Back".localized
		case .verifySecurity:
			return "Social.Verify.Back".localized
		}
	}
	
	var title: String {
		switch self {
		case .setSecurity:
			return "Social.Title.Set".localized
		case .confirmSecurity:
			return "Social.Title.Confirm".localized
		case .verifySecurity:
			return "Social.Title.Verify".localized
		}
	}
	
	var buttonNext: String {
		switch self {
		case .setSecurity:
			return "Social.Next".localized
		case .confirmSecurity:
			return "Social.Next".localized
		case .verifySecurity:
			return "Social.Verify.Next".localized
		}
	}
	
	var textInput: String {
		switch self {
		case .setSecurity:
			return "Social.Security.Set".localized
		case .confirmSecurity:
			return "Social.Security.Confirm".localized
		case .verifySecurity:
			return "Social.Input.Verify".localized
		}
	}
	
	var textInputDescription: String {
		switch self {
		case .setSecurity:
			return "Social.Security.Set.Description".localized
		default:
			return ""
		}
	}
	
	func nextView(userName: String, customServer: Binding<CustomServer>) -> AnyView {
		switch self {
		case .setSecurity:
			return AnyView(SocialView(userName: userName, socialStyle: .confirmSecurity, customServer: customServer))
		case .confirmSecurity:
			return AnyView(SocialView(userName: userName, socialStyle: .verifySecurity, customServer: customServer))
		case .verifySecurity:
			return AnyView(SocialView(userName: userName, socialStyle: .verifySecurity, customServer: customServer))
		}
	}
}
