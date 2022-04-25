//
//  ColorStyle.swift
//  CommonUI
//
//  Created by NamNH on 01/11/2021.
//

import SwiftUI

public protocol IColorSet {
	// MARK: - Grayscale
	var black: Color { get }
	var grey1: Color { get }
	var grey2: Color { get }
	var darkGrey2: Color { get }
	var greyLight2: Color { get }
	var grey3: Color { get }
	var darkgrey3: Color { get }
	var grey4: Color { get }
	var grey5: Color { get }
	var greyLight: Color { get }
	var background: Color { get }
	var offWhite: Color { get }
	
	// MARK: - Primary
	var primaryDefault: Color { get }
	var primaryDark: Color { get }
	var primaryLight: Color { get }
	
	// MARK: - Secondary
	var secondaryDefault: Color { get }
	var secondaryDark: Color { get }
	var secondaryLight: Color { get }
	
	// MARK: - Error
	var errorDefault: Color { get }
	var errorDark: Color { get }
	var errorLight: Color { get }
	
	// MARK: - Success
	var successDefault: Color { get }
	var successDark: Color { get }
	var successLight: Color { get }
	
	// MARK: - Warning
	var warningDefault: Color { get }
	var warningDark: Color { get }
	var warningLight: Color { get }
	
	// MARK: - Gradient Primary
	var gradientPrimary: [Color] { get }
	
	// MARK: - Gradient Secondary
	var gradientSecondary: [Color] { get }
	
	// MARK: - Gradient Accent
	var gradientAccent: [Color] { get }
	// MARK: - Gradient Black
	var gradientBlack: [Color] { get }
	// MARK: - Gradient Linear
	var gradientLinear: [Color] { get }
	
	func color(of label: ColorStyle) -> Color
}

public enum ColorStyle {
	case header
	case normal
	case highlighted
	case disabled
	case selected
	case success
	case error
	case warning
	case input
	case placeholder
	case primaryText
}
