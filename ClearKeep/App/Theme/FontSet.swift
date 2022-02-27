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
		case inter = "Inter"
	}
	
	enum Weight: String {
		case bold = "Bold"
		case regular = "Regular"
		case light = "Light"
		case medium = "Medium"
	}
	
	enum Size: CGFloat {
		case extraExtraExtraLarge = 60.0
		case extraExtraExtraMediumLarge = 48.0
		case extraExtraMediumLarge = 40.0
		case extraExtraLarge = 34.0
		case extraLarge = 28.0
		case extraMediumLarge = 25.0
		case large = 24.0
		case extraMedium = 22.0
		case medium = 18.0
		case regular = 16.0
		case small = 14.0
		case extraSmall = 12.0
		case extraExtraSmall = 10.0
	}
	
	var heading1: UIFont { font(name: .inter, weight: .medium, size: .regular) }
	
	var body1: UIFont { font(name: .inter, weight: .medium, size: .regular) }
	
	var display4: UIFont { font(name: .inter, weight: .medium, size: .regular) }
	
	func font(style: FontStyle) -> UIFont {
		switch style {
		case .heading1:
			return heading1
		case .body1:
			return body1
		default:
			return display4
		}
	}
	
	func font(name: Font, weight: Weight, size: Size) -> UIFont {
		let fullname = "\(name)-\(weight)"
		return UIFont(name: fullname, size: size.rawValue) ?? UIFont.systemFont(ofSize: size.rawValue)
	}
}
