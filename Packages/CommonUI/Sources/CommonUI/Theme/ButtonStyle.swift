//
//  ButtonStyle.swift
//  CommonUI
//
//  Created by NamNH on 02/11/2021.
//

import UIKit
import Foundation

private enum Constants {
	static let cornerRadius: CGFloat = 12.0
}

public enum ButtonStyle {
	case `default`
	case primary
	case cancelled
	case selected
	case deselected
	case border
	
	public var backgroundColor: UIColor {
		switch self {
		case .default:
			return commonUIConfig.colorSet.blue700
		case .border:
			return .white
		case .cancelled:
			return commonUIConfig.colorSet.white
		default:
			return commonUIConfig.colorSet.blue700
		}
	}
	
	public var disabledBackgroundColor: UIColor {
		switch self {
		case .default:
			return commonUIConfig.colorSet.blue700.withAlphaComponent(0.3)
		case .border:
			return .white.withAlphaComponent(0.3)
		default:
			return commonUIConfig.colorSet.blue700.withAlphaComponent(0.3)
		}
	}
	
	public var highlightedBackgroundColor: UIColor {
		switch self {
		case .default:
			return commonUIConfig.colorSet.blue700.withAlphaComponent(0.3)
		case .border:
			return .white.withAlphaComponent(0.3)
		default:
			return commonUIConfig.colorSet.blue700.withAlphaComponent(0.3)
		}
	}
	
	public var borderColor: UIColor {
		switch self {
		case .border:
			return commonUIConfig.colorSet.blue700
		default:
			return .clear
		}
	}
	
	public var textColor: UIColor {
		switch self {
		case .border:
			return commonUIConfig.colorSet.blue700
		case .cancelled:
			return commonUIConfig.colorSet.neutral500
		default:
			return commonUIConfig.colorSet.white
		}
	}
	
	public var disabledTextColor: UIColor {
		switch self {
		case .border:
			return commonUIConfig.colorSet.blue700
		default:
			return commonUIConfig.colorSet.white
		}
	}
	
	public var highlightedTextColor: UIColor {
		switch self {
		case .border:
			return commonUIConfig.colorSet.blue700
		default:
			return commonUIConfig.colorSet.white
		}
	}
	
	public var textStyle: TextStyle {
		switch self {
		case .border:
			return .textM
		default:
			return .textM
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
