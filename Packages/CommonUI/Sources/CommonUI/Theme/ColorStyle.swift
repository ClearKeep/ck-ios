//
//  ColorStyle.swift
//  CommonUI
//
//  Created by NamNH on 01/11/2021.
//

import UIKit
import SwiftUI
import Common

public protocol IColorSet {
	var black: UIColor { get }
	var gray1: UIColor { get }
	var gray2: UIColor { get }
	var gray3: UIColor { get }
	var gray3Dark: UIColor { get }
	var gray4: UIColor { get }
	var gray5: UIColor { get }
	var gray5Dark: UIColor { get }
	var graylight: UIColor { get }
	var background: UIColor { get }
	var offWhite: UIColor { get }

	var primary: UIColor { get }
	var primaryDark: UIColor { get }
	var primaryLight: UIColor { get }

	var secondary: UIColor { get }
	var secondaryDark: UIColor { get }
	var secondaryLight: UIColor { get }

	var error: UIColor { get }
	var errorDark: UIColor { get }
	var errorLight: UIColor { get }

	var success: UIColor { get }
	var successDark: UIColor { get }
	var successLight: UIColor { get }

	var warning: UIColor { get }
	var warningDark: UIColor { get }
	var warningLight: UIColor { get }

	var gradientPrimary: LinearGradient { get }
	var gradientPrimaryDark: UIColor { get }
	var gradientPrimaryLight: UIColor { get }

	var gradientSecondary: LinearGradient { get }
	var gradientSecondaryDark: UIColor { get }
	var gradientSecondaryLight: UIColor { get }

	var gradientAccent: LinearGradient { get }
	var gradientAccentDark: UIColor { get }
	var gradientAccentLight: UIColor { get }

	func color(of label: ColorStyle) -> UIColor
}

public enum ColorStyle {
	case initial
	case active
	case typing
	case filled
	case disabled
	case error
	case success
	case caption
}
