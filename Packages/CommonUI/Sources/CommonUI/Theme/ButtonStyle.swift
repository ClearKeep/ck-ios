//
//  File.swift
//
//
//  Created by MinhDev on 25/02/2022.
//
import SwiftUI

private enum Constants {
	static let cornerRadius: CGFloat = 40.0
}

public enum ButtonIcon {
	case google
	case facebook
	case office

	public var iconImage: UIImage {
		switch self {
		case .google:
			return commonUIConfig.imageSet.googleIcon
		case .facebook:
			return commonUIConfig.imageSet.facebookIcon
		case .office:
			return commonUIConfig.imageSet.officeIcon
		}
	}
}
