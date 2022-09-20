//
//  ColorSet.swift
//  iOSBase
//
//  Created by NamNH on 02/11/2021.
//

import CommonUI
import SwiftUI

protocol IAppColorSet: IColorSet, ICommonUIColorSet {}

struct ColorSet: IAppColorSet {
	// MARK: - Grayscale
	var black: Color { Color(UIColor(hex: "#000000")) }
	var grey1: Color { Color(UIColor(hex: "#4E4B66")) }
	var grey2: Color { Color(UIColor(hex: "#6E7191")) }
	var darkGrey2: Color { Color(UIColor(hex: "#3B3B3B")) }
	var greyLight2: Color { Color(UIColor(hex: "#E0E0E0")) }
	var grey3: Color { Color(UIColor(hex: "#A0A3BD")) }
	var darkgrey3: Color { Color(UIColor(hex: "#424242")) }
	var grey4: Color { Color(UIColor(hex: "#D9DBE9")) }
	var grey5: Color { Color(UIColor(hex: "#EFF0F6")) }
	var grey6: Color { Color(UIColor(hex: "#222222")) }
	var greyLight: Color { Color(UIColor(hex: "#C4C4C4")) }
	var greyLight3: Color { Color(UIColor(hex: "#2C3E50")) }
	var background: Color { Color(UIColor(hex: "#F7F7FC")) }
	var offWhite: Color { Color(UIColor(hex: "#FCFCFC")) }
	
	// MARK: - Primary
	var primaryDefault: Color { Color(UIColor(hex: "#6267FB")) }
	var primaryDark: Color { Color(UIColor(hex: "#363BD0")) }
	var primaryLight: Color { Color(UIColor(hex: "#898DFF")) }
	
	// MARK: - Secondary
	var secondaryDefault: Color { Color(UIColor(hex: "#E06464")) }
	var secondaryDark: Color { Color(UIColor(hex: "#D42B2B")) }
	var secondaryLight: Color { Color(UIColor(hex: "#E99191")) }
	
	// MARK: - Error
	var errorDefault: Color { Color(UIColor(hex: "#ED2E7E")) }
	var errorDark: Color { Color(UIColor(hex: "#C30052")) }
	var errorLight: Color { Color(UIColor(hex: "#FFE8F1")) }
	
	// MARK: - Success
	var successDefault: Color { Color(UIColor(hex: "#00BA88")) }
	var successDark: Color { Color(UIColor(hex: "#00966D")) }
	var successLight: Color { Color(UIColor(hex: "#DBFFF5")) }
	
	// MARK: - Warning
	var warningDefault: Color { Color(UIColor(hex: "#F4B740")) }
	var warningDark: Color { Color(UIColor(hex: "#946200")) }
	var warningLight: Color { Color(UIColor(hex: "#FFD789")) }
	
	// MARK: - Gradient Primary
	var gradientPrimary: [Color] { [Color(UIColor(hex: "#7773F3")), Color(UIColor(hex: "#8ABFF3"))] }
	
	// MARK: - Gradient Secondary
	var gradientSecondary: [Color] { [Color(UIColor(hex: "#4147FB")), Color(UIColor(hex: "#64A1E0"))] }
	
	// MARK: - Gradient Accent
	var gradientAccent: [Color] { [Color(UIColor(hex: "#E06464")), Color(UIColor(hex: "#E99191"))] }

	// MARK: - Gradient Black
	var gradientBlack: [Color] { [Color(UIColor(hex: "#000000")), Color(UIColor(hex: "#000000"))] }
	// MARK: - Gradient Linear
	var gradientLinear: [Color] { [Color(UIColor(hex: "#7773F3")), Color(UIColor(hex: "#8ABFF3"))] }
	
	// MARK: - Loading
	var lightLoading: Color { Color(UIColor(hex: "#363BD0")) }
	var darkLoading: Color { Color(UIColor(hex: "#898DFF")) }
	
	func color(of label: ColorStyle) -> Color {
		return Color(UIColor(hex: "#"))
	}
	
	// MARK: - Seperator
	var seperatorDefault: Color { Color(UIColor(hex: "#545458")).opacity(0.65) }
}
