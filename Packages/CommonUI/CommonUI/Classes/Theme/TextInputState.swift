//
//  TextInputStyle.swift
//
//
//  Created by NamNH on 03/03/2022.
//

import SwiftUI

private enum Constants {
	static let cornerRadius: CGFloat = 16.0
	static let cornerRadiusPasscode: CGFloat = 8.0
}

protocol ITextInputStyle {
	var backgroundColorLight: Color { get }
	var backgroundColorDark: Color { get }
	var tintColorLight: Color { get }
	var tintColorDark: Color { get }
	var borderColorLight: Color { get }
	var borderColorDark: Color { get }
	var borderWidth: CGFloat { get }
	var textColorLight: Color { get }
	var textColorDark: Color { get }
	var placeHolderColorLight: Color { get }
	var placeHolderColorDark: Color { get }
	var notifyColorLight: Color { get }
	var notifyColorDark: Color { get }
}

public enum TextInputStyle: ITextInputStyle {

	case `default`
	case normal
	case disabled
	case highlighted
	case error(message: String)
	case success(message: String)

	public var backgroundColorLight: Color {
		switch self {
		case .default:
			return commonUIConfig.colorSet.grey5
		case .normal:
			return commonUIConfig.colorSet.grey5
		case .disabled:
			return commonUIConfig.colorSet.grey5.opacity(0.5)
		case .highlighted:
			return commonUIConfig.colorSet.offWhite
		case .error:
			return commonUIConfig.colorSet.errorLight
		case .success:
			return commonUIConfig.colorSet.successLight
		}
	}

	public var backgroundColorDark: Color {
		switch self {
		case .default:
			return commonUIConfig.colorSet.darkgrey3
		case .normal:
			return commonUIConfig.colorSet.darkgrey3
		case .disabled:
			return commonUIConfig.colorSet.darkgrey3.opacity(0.5)
		case .highlighted:
			return commonUIConfig.colorSet.darkgrey3
		case .error:
			return commonUIConfig.colorSet.primaryDefault
		case .success:
			return commonUIConfig.colorSet.successLight
		}
	}

	public var tintColorLight: Color {
		switch self {
		case .default:
			return commonUIConfig.colorSet.grey1
		case .normal:
			return commonUIConfig.colorSet.grey1
		case .disabled:
			return commonUIConfig.colorSet.grey5.opacity(0.5)
		case .highlighted:
			return commonUIConfig.colorSet.black
		case .error:
			return commonUIConfig.colorSet.errorLight
		case .success:
			return commonUIConfig.colorSet.successLight
		}
	}

	public var tintColorDark: Color {
		switch self {
		case .default:
			return commonUIConfig.colorSet.greyLight
		case .normal:
			return commonUIConfig.colorSet.greyLight
		case .disabled:
			return commonUIConfig.colorSet.greyLight.opacity(0.5)
		case .highlighted:
			return commonUIConfig.colorSet.greyLight
		case .error:
			return commonUIConfig.colorSet.greyLight
		case .success:
			return commonUIConfig.colorSet.greyLight
		}
	}

	public var borderColorLight: Color {
		switch self {
		case .default:
			return commonUIConfig.colorSet.grey5
		case .normal:
			return commonUIConfig.colorSet.grey5
		case .disabled:
			return commonUIConfig.colorSet.grey5.opacity(0.5)
		case .highlighted:
			return commonUIConfig.colorSet.black
		case .error:
			return commonUIConfig.colorSet.errorDefault
		case .success:
			return commonUIConfig.colorSet.successDefault
		}
	}

	public var borderColorDark: Color {
		switch self {
		case .default:
			return commonUIConfig.colorSet.darkgrey3
		case .normal:
			return commonUIConfig.colorSet.darkgrey3
		case .disabled:
			return commonUIConfig.colorSet.darkgrey3.opacity(0.5)
		case .highlighted:
			return commonUIConfig.colorSet.greyLight
		case .error:
			return commonUIConfig.colorSet.primaryDefault
		case .success:
			return commonUIConfig.colorSet.successDefault
		}
	}

	public var textColorLight: Color {
		switch self {
		case .default:
			return commonUIConfig.colorSet.grey3
		case .normal:
			return commonUIConfig.colorSet.black
		case .disabled:
			return commonUIConfig.colorSet.grey3.opacity(0.5)
		case .highlighted:
			return commonUIConfig.colorSet.black
		case .error:
			return commonUIConfig.colorSet.grey1
		case .success:
			return commonUIConfig.colorSet.grey1
		}
	}

	public var textColorDark: Color {
		switch self {
		case .default:
			return commonUIConfig.colorSet.greyLight
		case .normal:
			return commonUIConfig.colorSet.greyLight
		case .disabled:
			return commonUIConfig.colorSet.greyLight.opacity(0.5)
		case .highlighted:
			return commonUIConfig.colorSet.greyLight
		case .error:
			return commonUIConfig.colorSet.greyLight
		case .success:
			return commonUIConfig.colorSet.greyLight
		}
	}

	public var placeHolderColorLight: Color {
		return commonUIConfig.colorSet.grey3
	}

	public var placeHolderColorDark: Color {
		return commonUIConfig.colorSet.grey3
	}

	public var textStyle: TextStyle {
		return .textM
	}

	public var cornerRadius: CGFloat {
		return Constants.cornerRadius
	}

	public var cornerRadiusPasscode: CGFloat {
		return Constants.cornerRadiusPasscode
	}

	public var borderWidth: CGFloat {
		switch self {
		case .default:
			return 0.0
		case .normal:
			return 2.0
		case .disabled:
			return 0.0
		case .highlighted:
			return 2.0
		case .error:
			return 2.0
		case .success:
			return 2.0
		}
	}

	public var notifyColorLight: Color {
		switch self {
		case .default:
			return commonUIConfig.colorSet.black
		case .normal:
			return commonUIConfig.colorSet.black
		case .disabled:
			return commonUIConfig.colorSet.black
		case .highlighted:
			return commonUIConfig.colorSet.black
		case .error:
			return commonUIConfig.colorSet.errorLight
		case .success:
			return commonUIConfig.colorSet.successLight
		}
	}

	public var notifyColorDark: Color {
		switch self {
		case .default:
			return commonUIConfig.colorSet.black
		case .normal:
			return commonUIConfig.colorSet.black
		case .disabled:
			return commonUIConfig.colorSet.black
		case .highlighted:
			return commonUIConfig.colorSet.black
		case .error:
			return commonUIConfig.colorSet.primaryDefault
		case .success:
			return commonUIConfig.colorSet.successLight
		}
	}
}
