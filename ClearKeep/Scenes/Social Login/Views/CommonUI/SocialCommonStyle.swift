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
}

public enum SocialCommonStyle: ISocialCommonStyle {
	case setSecurity
	case confirmSecurity
	case verifySecurity

	public var buttonBack: String {
		switch self {
		case .setSecurity:
			return "Social.setPhrase.back"
		case .confirmSecurity:
			return "Social.confirmPhrase.back"
		case .verifySecurity:
			return "Social.verify.back"
		}
	}

	public var title: String {
		switch self {
		case .setSecurity:
			return "Social.title.set"
		case .confirmSecurity:
			return "Social.title.confirm"
		case .verifySecurity:
			return "Social.title.verify"
		}
	}

	public var buttonNext: String {
		switch self {
		case .setSecurity:
			return "Social.next"
		case .confirmSecurity:
			return "Social.next"
		case .verifySecurity:
			return "Social.verify.next"
		}
	}

	public var textInput: String {
		switch self {
		case .setSecurity:
			return "Social.security.set"
		case .confirmSecurity:
			return "Social.security.confirm"
		case .verifySecurity:
			return "Social.input.verify"
		}
	}
}
