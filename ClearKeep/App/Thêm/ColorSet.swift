//
//  ColorSet.swift
//  iOSBase
//
//  Created by NamNH on 02/11/2021.
//

import CommonUI
import UIKit
import SwiftUI

struct ColorSet: IColorSet {

	var black: UIColor { UIColor(hex: "#000000") }
	var gray1: UIColor { UIColor(hex: "#4E4B66") }
	var gray2: UIColor { UIColor(hex: "#6E7191") }
	var gray3: UIColor { UIColor(hex: "#A0A3BD") }
	var gray4: UIColor { UIColor(hex: "#D9DBE9") }
	var gray5: UIColor { UIColor(hex: "#EFF0F6") }
	var graylight: UIColor { UIColor(hex: "#E0E0E0") }
	var gray3Dark: UIColor { UIColor(hex: "#C4C4C4") }
	var gray5Dark: UIColor { UIColor(hex: "#424242") }


	var background: UIColor { UIColor(hex: "F7F7FC") }
	var offWhite: UIColor { UIColor(hex: "FCFCFC") }
	var primary: UIColor { UIColor(hex: "#6267FB") }
	var primaryDark: UIColor { UIColor(hex: "#363BD0") }
	var primaryLight: UIColor { UIColor(hex: "#898DFF") }
	var secondary: UIColor { UIColor(hex: "#E06464") }
	var secondaryDark: UIColor { UIColor(hex: "#D42B2B") }
	var secondaryLight: UIColor { UIColor(hex: "#E99191") }
	var error: UIColor { UIColor(hex: "#ED2E7E") }
	var errorDark: UIColor { UIColor(hex: "#C30052") }
	var errorLight: UIColor { UIColor(hex: "#FFE8F1") }
	var success: UIColor { UIColor(hex: "#00BA88") }
	var successDark: UIColor { UIColor(hex: "#00966D") }
	var successLight: UIColor { UIColor(hex: "#DBFFF5") }
	var warning: UIColor { UIColor(hex: "#F4B740") }
	var warningDark: UIColor { UIColor(hex: "#946200") }
	var warningLight: UIColor { UIColor(hex: "#FFD789") }
	var gradientPrimary: LinearGradient { LinearGradient(gradient: Gradient(colors: [Color(UIColor(hex: "#7773F3")), Color(UIColor(hex: "#8ABFF3"))]), startPoint: .topLeading, endPoint: .bottomTrailing) }
	var gradientPrimaryDark: UIColor { UIColor(hex: "#7773F3") }
	var gradientPrimaryLight: UIColor { UIColor(hex: "#8ABFF3") }
	var gradientSecondary: LinearGradient { LinearGradient(gradient: Gradient(colors: [Color(UIColor(hex: "#4147FB")), Color(UIColor(hex: "#64A1E0"))]), startPoint: .topLeading, endPoint: .bottomTrailing) }
	var gradientSecondaryDark: UIColor { UIColor(hex: "#363BD0") }
	var gradientSecondaryLight: UIColor { UIColor(hex: "#64A1E0") }
	var gradientAccent: LinearGradient { LinearGradient(gradient: Gradient(colors: [Color(UIColor(hex: "#E06464")), Color(UIColor(hex: "#E99191"))]), startPoint: .topLeading, endPoint: .bottomTrailing) }
	var gradientAccentDark: UIColor { UIColor(hex: "#E06464") }
	var gradientAccentLight: UIColor { UIColor(hex: "#E99191") }
	
	func color(of label: ColorStyle) -> UIColor {
		switch label {
		case .initial:
			return gray5
		case .active:
			return offWhite
		case .typing:
			return offWhite
		case .filled:
			return gray5
		case .disabled:
			return gray5
		case .error:
			return errorLight
		case .success:
			return successLight
		case .caption:
			return gray5
		default:
			return gray5
		}
	}
}
