//
//  ColorSet.swift
//  iOSBase
//
//  Created by NamNH on 02/11/2021.
//

import CommonUI
import UIKit

struct ColorSet: IColorSet {
	var neutral: UIColor { UIColor(hex: "") }
	var neutral100: UIColor { UIColor(hex: "#FFFFFF") }
	var neutral200: UIColor { UIColor(hex: "#F7F7F7") }
	var neutral300: UIColor { UIColor(hex: "#EBECED") }
	var neutral400: UIColor { UIColor(hex: "#D6D9DB") }
	var neutral500: UIColor { UIColor(hex: "#9AA0A5") }
	var neutral600: UIColor { UIColor(hex: "#34404B") }
	
	var red: UIColor { UIColor.red }
	var red100: UIColor { UIColor(hex: "#F9E8E8") }
	var red600: UIColor { UIColor(hex: "#FA3232") }
	
	var green: UIColor { UIColor.green }
	var green100: UIColor { UIColor(hex: "#E2FADC") }
	var green500: UIColor { UIColor(hex: "#62B47F") }
	
	var yellow: UIColor { UIColor.yellow }
	var yellow100: UIColor { UIColor(hex: "#FAF7DC") }
	var yellow300: UIColor { UIColor(hex: "#FEBD47") }
	var yellow500: UIColor { UIColor(hex: "#B78915") }
	
	var gray: UIColor { UIColor.gray }
	var gray25: UIColor { UIColor(hex: "#FAFAFE") }
	var gray50: UIColor { UIColor(hex: "#F8F8FC") }
	var gray75: UIColor { UIColor(hex: "#F5F5F5") }
	var gray100: UIColor { UIColor(hex: "#F1F1F1") }
	var gray150: UIColor { UIColor(hex: "#E5E5E5") }
	
	var white: UIColor { UIColor.white }
	var black: UIColor { UIColor.black }
	
	var blue: UIColor { UIColor.blue }
	var blue100: UIColor { UIColor(hex: "#5B97FF") }
	var blue200: UIColor { UIColor(hex: "#568DEB") }
	var blue400: UIColor { UIColor(hex: "#335FAE") }
	var blue600: UIColor { UIColor(hex: "#142848") }
	var blue700: UIColor { UIColor(hex: "#0957DE") }
	
	func color(of label: ColorStyle) -> UIColor {
		switch label {
		case .header:
			return blue600
		case .normal:
			return neutral500
		case .error:
			return red600
		case .placeholder:
			return neutral400
		case .primaryText:
			return neutral500
		default: return .black
		}
	}
}
