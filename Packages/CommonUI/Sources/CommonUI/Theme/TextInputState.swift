//
//  TextInputStyle.swift
//  
//
//  Created by NamNH on 03/03/2022.
//

import SwiftUI

private enum Constants {
	static let cornerRadius: CGFloat = 16.0
}

protocol ITextInputStyle {
	var backgroundColor: Color { get }
	var tintColor: Color { get }
	var borderColor: Color { get }
	var borderWidth: CGFloat { get }
	var textColor: Color { get }
	var placeHolderColor: Color { get }
	var notifyColor: Color { get }
}

public enum TextInputStyle: ITextInputStyle {
	case `default`
	case normal
	case disabled
	case highlighted
	case error(message: String)
	case success(message: String)
	
	public var backgroundColor: Color {
		switch self {
		case .default:
			return commonUIConfig.colorSet.grey5
		case .normal:
			return commonUIConfig.colorSet.offWhite
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
	
	public var tintColor: Color {
		switch self {
		case .default:
			return commonUIConfig.colorSet.grey5
		case .normal:
			return commonUIConfig.colorSet.offWhite
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
	
	public var borderColor: Color {
		switch self {
		case .default:
			return commonUIConfig.colorSet.grey5
		case .normal:
			return commonUIConfig.colorSet.black
		case .disabled:
			return commonUIConfig.colorSet.grey5
		case .highlighted:
			return commonUIConfig.colorSet.black
		case .error:
			return commonUIConfig.colorSet.errorLight
		case .success:
			return commonUIConfig.colorSet.successLight
		}
	}
	
	public var textColor: Color {
		switch self {
		case .default:
			return commonUIConfig.colorSet.grey1
		case .normal:
			return commonUIConfig.colorSet.black
		case .disabled:
			return commonUIConfig.colorSet.grey3
		case .highlighted:
			return commonUIConfig.colorSet.black
		case .error:
			return commonUIConfig.colorSet.grey1
		case .success:
			return commonUIConfig.colorSet.grey1
		}
	}
	
	public var placeHolderColor: Color {
		return commonUIConfig.colorSet.grey3
	}
	
	public var textStyle: TextStyle {
		return .textM
	}
	
	public var cornerRadius: CGFloat {
		return Constants.cornerRadius
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
	
	public var notifyColor: Color {
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
}
