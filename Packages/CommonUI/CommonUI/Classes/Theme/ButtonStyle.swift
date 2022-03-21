//
//  ButtonStyle.swift
//  CommonUI
//
//  Created by NamNH on 02/11/2021.
//

import SwiftUI

private enum Constants {
	static let cornerRadius: CGFloat = 16.0
}

protocol IButtonStyle {
	var backgroundColor: [Color] { get }
	var disabledBackgroundColor: [Color] { get }
	var highlightedBackgroundColor: [Color] { get }
	var borderColor: [Color] { get }
	var disabledBorderColor: [Color] { get }
	var borderWidth: CGFloat { get }
	var textColor: [Color] { get }
	var disabledTextColor: [Color] { get }
}

public enum ButtonStyle: IButtonStyle {
	case primary
	case secondary
	case subtle
	case text
	
	public var backgroundColor: [Color] {
		switch self {
		case .primary:
			return commonUIConfig.colorSet.gradientPrimary
		case .secondary:
			return [commonUIConfig.colorSet.offWhite, commonUIConfig.colorSet.offWhite]
		case .subtle:
			return [commonUIConfig.colorSet.offWhite, commonUIConfig.colorSet.offWhite]
		case .text:
			return [commonUIConfig.colorSet.offWhite, commonUIConfig.colorSet.offWhite]
		}
	}
	
	public var disabledBackgroundColor: [Color] {
		switch self {
		case .primary:
			return commonUIConfig.colorSet.gradientPrimary.compactMap({ $0.opacity(0.5) })
		case .secondary:
			return [commonUIConfig.colorSet.offWhite, commonUIConfig.colorSet.offWhite].compactMap({ $0.opacity(0.5) })
		case .subtle:
			return [commonUIConfig.colorSet.offWhite, commonUIConfig.colorSet.offWhite].compactMap({ $0.opacity(0.5) })
		case .text:
			return [commonUIConfig.colorSet.offWhite, commonUIConfig.colorSet.offWhite].compactMap({ $0.opacity(0.5) })
		}
	}
	
	public var highlightedBackgroundColor: [Color] {
		switch self {
		case .primary:
			return commonUIConfig.colorSet.gradientPrimary
		case .secondary:
			return [commonUIConfig.colorSet.offWhite, commonUIConfig.colorSet.offWhite]
		case .subtle:
			return [commonUIConfig.colorSet.offWhite, commonUIConfig.colorSet.offWhite]
		case .text:
			return [commonUIConfig.colorSet.offWhite, commonUIConfig.colorSet.offWhite]
		}
	}
	
	public var borderColor: [Color] {
		switch self {
		case .primary:
			return commonUIConfig.colorSet.gradientPrimary
		case .secondary:
			return [commonUIConfig.colorSet.offWhite, commonUIConfig.colorSet.offWhite]
		case .subtle:
			return [commonUIConfig.colorSet.offWhite, commonUIConfig.colorSet.offWhite]
		case .text:
			return [commonUIConfig.colorSet.offWhite, commonUIConfig.colorSet.offWhite]
		}
	}
	
	public var disabledBorderColor: [Color] {
		switch self {
		case .primary:
			return commonUIConfig.colorSet.gradientPrimary.compactMap({ $0.opacity(0.5) })
		case .secondary:
			return [commonUIConfig.colorSet.offWhite, commonUIConfig.colorSet.offWhite].compactMap({ $0.opacity(0.5) })
		case .subtle:
			return [commonUIConfig.colorSet.offWhite, commonUIConfig.colorSet.offWhite].compactMap({ $0.opacity(0.5) })
		case .text:
			return [commonUIConfig.colorSet.offWhite, commonUIConfig.colorSet.offWhite].compactMap({ $0.opacity(0.5) })
		}
	}
	
	public var textColor: [Color] {
		switch self {
		case .primary:
			return commonUIConfig.colorSet.gradientPrimary.compactMap({ $0.opacity(0.5) })
		case .secondary:
			return [commonUIConfig.colorSet.offWhite, commonUIConfig.colorSet.offWhite].compactMap({ $0.opacity(0.5) })
		case .subtle:
			return [commonUIConfig.colorSet.offWhite, commonUIConfig.colorSet.offWhite].compactMap({ $0.opacity(0.5) })
		case .text:
			return [commonUIConfig.colorSet.offWhite, commonUIConfig.colorSet.offWhite].compactMap({ $0.opacity(0.5) })
		}
	}
	
	public var disabledTextColor: [Color] {
		switch self {
		case .primary:
			return commonUIConfig.colorSet.gradientPrimary.compactMap({ $0.opacity(0.5) })
		case .secondary:
			return [commonUIConfig.colorSet.offWhite, commonUIConfig.colorSet.offWhite].compactMap({ $0.opacity(0.5) })
		case .subtle:
			return [commonUIConfig.colorSet.offWhite, commonUIConfig.colorSet.offWhite].compactMap({ $0.opacity(0.5) })
		case .text:
			return [commonUIConfig.colorSet.offWhite, commonUIConfig.colorSet.offWhite].compactMap({ $0.opacity(0.5) })
		}
	}
	
	public var textStyle: TextStyle {
		return .textM
	}
	
	public var cornerRadius: CGFloat {
		return Constants.cornerRadius
	}
	
	public var borderWidth: CGFloat {
		switch self {
		case .primary:
			return 2.0
		case .secondary:
			return 2.0
		case .subtle:
			return 2.0
		case .text:
			return 0.0
		}
	}
}
