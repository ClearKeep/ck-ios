//
//  FontSet.swift
//  iOSBase
//
//  Created by NamNH on 02/11/2021.
//

import UIKit
import CommonUI

struct DefaultFontSet: IFontSet {
	enum Font: String {
		case sfPro = "SFProDisplay"
	}
	
	enum Weight: String {
		case bold = "Bold"
		case regular = "Regular"
	}
	
	enum Size: CGFloat {
		case large = 42.0
		case medium = 32.0
		case small = 24.0
		case extraSmall = 12.0
		case tLarge = 20.0
		case tMedium = 16.0
		case tSmall = 14.0
	}

	var displayL: UIFont { font(name: .sfPro, weight: .regular, size: .large) }
	var displayM: UIFont { font(name: .sfPro, weight: .regular, size: .medium) }
	var displayS: UIFont { font(name: .sfPro, weight: .regular, size: .small) }
	var displayLB: UIFont { font(name: .sfPro, weight: .bold, size: .large) }
	var displayMB: UIFont { font(name: .sfPro, weight: .bold, size: .medium) }
	var displaySB: UIFont { font(name: .sfPro, weight: .bold, size: .small) }
	var textL: UIFont { font(name: .sfPro, weight: .regular, size: .tLarge) }
	var textM: UIFont { font(name: .sfPro, weight: .regular, size: .tMedium) }
	var textS: UIFont { font(name: .sfPro, weight: .regular, size: .tSmall) }
	var textXS: UIFont { font(name: .sfPro, weight: .regular, size: .extraSmall) }
	var linkL: UIFont { font(name: .sfPro, weight: .bold, size: .tLarge) }
	var linkM: UIFont { font(name: .sfPro, weight: .bold, size: .tMedium) }
	var linkS: UIFont { font(name: .sfPro, weight: .bold, size: .tSmall) }
	var linkXS: UIFont { font(name: .sfPro, weight: .bold, size: .extraSmall) }
		
	func font(style: FontStyle) -> UIFont {
		switch style {
		case .displayL:
			return displayL
		case .displayS:
			return displayS
		case .displayM:
			return displayM
		case .displayLB:
			return displayLB
		case .displayMB:
			return displayMB
		case .displaySB:
			return displaySB
		case .textL:
			return textL
		case .textM:
			return textM
		case .textS:
			return textS
		case .textXS:
			return textXS
		case .linkL:
			return linkL
		case .linkM:
			return linkM
		case .linkS:
			return linkS
		case .linkXS:
			return linkS
		}
	}
	
	func font(name: Font, weight: Weight, size: Size) -> UIFont {
		let fullname = "\(name)-\(weight)"
		return UIFont(name: fullname, size: size.rawValue) ?? UIFont.systemFont(ofSize: size.rawValue)
	}
}
