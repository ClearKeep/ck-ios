//
//  SocialCommonStyle.swift
//  ClearKeep
//
//  Created by đông on 18/03/2022.
//

import SwiftUI

protocol ISocialCommonStyle {
	var buttonBack: String { get }
	var title: String { get }
	var buttonNext: String { get }
	associatedtype NextView
	var nextView: NextView { get }
}

public enum SocialCommonStyle: ISocialCommonStyle {

	case setSecurity
	case confirmSecurity
	case verifySecurity
	case currentPassword

	public var buttonBack: String {
		switch self {
		case .setSecurity:
			return "Social.SetPhrase.Back"
		case .confirmSecurity:
			return "Social.ConfirmPhrase.Back"
		case .verifySecurity:
			return "Social.Verify.Back"
		case .currentPassword:
			return "CurrentPassword.ButtonBack"
		}
	}

	public var title: String {
		switch self {
		case .setSecurity:
			return "Social.Title.Set"
		case .confirmSecurity:
			return "Social.Title.Confirm"
		case .verifySecurity:
			return "Social.Title.Verify"
		case .currentPassword:
			return "CurrentPassword.Title"
		}
	}

	public var buttonNext: String {
		switch self {
		case .setSecurity:
			return "Social.Next"
		case .confirmSecurity:
			return "Social.Next"
		case .verifySecurity:
			return "Social.Verify.Next"
		case .currentPassword:
			return "CurrentPassword.Next"
		}
	}

	public var textInput: String {
		switch self {
		case .setSecurity:
			return "Social.Security.Set"
		case .confirmSecurity:
			return "Social.Security.Confirm"
		case .verifySecurity:
			return "Social.Input.Verify"
		case .currentPassword:
			return "CurrentPassword.Placeholder"
		}
	}

	public var validatePassPhrase: String {
		switch self {
		case .setSecurity:
			return "Social.Message"
		case .confirmSecurity:
			return ""
		case .verifySecurity:
			return ""
		case .currentPassword:
			return ""
		}
	}

	public var nextView: some View {
		switch self {
		case .setSecurity:
			return AnyView(SocialConfirm())
		case .confirmSecurity:
			return AnyView(SocialVerify())
		case .verifySecurity:
			return AnyView(SocialVerify())
		case .currentPassword:
			return AnyView(TwoFactorView())
		}
	}
}
