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

public enum ButtonStyles {
	case standard
	case active
	case loading
	case disabled
	case primary
	case secondary
	case subtle
	case text
	case border
	
	public var backgroundColor: UIColor {
		switch self {
		case .primary:
			return commonUIConfig.colorSet.primary
		case .secondary:
			return commonUIConfig.colorSet.offWhite
		default:
			return commonUIConfig.colorSet.offWhite
		}
	}
	
	public var backgroundGardientColor: LinearGradient {
		switch self {
		case .primary:
			return commonUIConfig.colorSet.gradientPrimary
		case .standard:
			return commonUIConfig.colorSet.gradientPrimary
		case .secondary:
			return commonUIConfig.colorSet.gradientPrimary
		default:
			return commonUIConfig.colorSet.gradientPrimary
		}
	}
	
	public var borderColor: UIColor {
		switch self {
		case .border:
			return commonUIConfig.colorSet.offWhite
		case .secondary:
			return commonUIConfig.colorSet.primaryLight
		case .subtle:
			return commonUIConfig.colorSet.gray4
		default:
			return commonUIConfig.colorSet.offWhite
		}
	}
	
	public var textColor: UIColor {
		switch self {
		case .border:
			return commonUIConfig.colorSet.primary
		case .disabled:
			return commonUIConfig.colorSet.primary
		default:
			return commonUIConfig.colorSet.primary
		}
	}
	
	public var disabledTextColor: UIColor {
		switch self {
		case .border:
			return commonUIConfig.colorSet.gray3.withAlphaComponent(0.3)
		default:
			return commonUIConfig.colorSet.primary.withAlphaComponent(0.3)
		}
	}
	
	public var highlightedTextColor: UIColor {
		switch self {
		case .disabled:
			return commonUIConfig.colorSet.graylight
		default:
			return commonUIConfig.colorSet.background
		}
	}
	
	public var cornerRadius: CGFloat {
		return Constants.cornerRadius
	}
	
	public var borderWidth: CGFloat {
		switch self {
		case .border:
			return 1.0
		default:
			return 0.0
		}
	}
}
