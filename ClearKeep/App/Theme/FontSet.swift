//
//  FontSet.swift
//  iOSBase
//
//  Created by NamNH on 02/11/2021.
//

import SwiftUI
import CommonUI

struct DefaultFontSet: IFontSet {
	func font(style: FontStyle) -> Font {
		switch style {
		case .heading1:
			return Font.system(size: 48.0, weight: Font.Weight.regular)
		case .heading2:
			return Font.system(size: 32.0, weight: Font.Weight.regular)
		case .heading3:
			return Font.system(size: 24.0, weight: Font.Weight.regular)
		case .body1:
			return Font.system(size: 20.0, weight: Font.Weight.bold)
		case .body2:
			return Font.system(size: 16.0, weight: Font.Weight.bold)
		case .body3:
			return Font.system(size: 14.0, weight: Font.Weight.bold)
		case .body4:
			return Font.system(size: 12.0, weight: Font.Weight.bold)
		case .input1:
			return Font.system(size: 20.0, weight: Font.Weight.regular)
		case .input2:
			return Font.system(size: 16.0, weight: Font.Weight.regular)
		case .input3:
			return Font.system(size: 14.0, weight: Font.Weight.regular)
		case .placeholder1:
			return Font.system(size: 16.0, weight: Font.Weight.regular)
		case .placeholder2:
			return Font.system(size: 14.0, weight: Font.Weight.regular)
		case .placeholder3:
			return Font.system(size: 12.0, weight: Font.Weight.regular)
		case .display1:
			return Font.system(size: 48.0, weight: Font.Weight.bold)
		case .display2:
			return Font.system(size: 32.0, weight: Font.Weight.bold)
		case .display3:
			return Font.system(size: 24.0, weight: Font.Weight.bold)
		}
	}
}
