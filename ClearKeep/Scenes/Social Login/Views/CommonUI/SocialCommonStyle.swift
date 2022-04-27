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

	public var buttonBack: String {
		switch self {
		case .setSecurity:
			return "Social.SetPhrase.Back"
		case .confirmSecurity:
			return "Social.ConfirmPhrase.Back"
		case .verifySecurity:
			return "Social.Verify.Back"
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
		}
	}
}
