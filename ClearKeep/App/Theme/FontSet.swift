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
			return Font.system(size: 44.0, weight: Font.Weight.bold)
		case .heading2:
			return Font.system(size: 44.0, weight: Font.Weight.bold)
		case .heading3:
			return Font.system(size: 44.0, weight: Font.Weight.bold)
		case .body1:
			return Font.system(size: 44.0, weight: Font.Weight.bold)
		case .body2:
			return Font.system(size: 44.0, weight: Font.Weight.bold)
		case .body3:
			return Font.system(size: 44.0, weight: Font.Weight.bold)
		case .input1:
			return Font.system(size: 44.0, weight: Font.Weight.bold)
		case .input2:
			return Font.system(size: 44.0, weight: Font.Weight.bold)
		case .input3:
			return Font.system(size: 44.0, weight: Font.Weight.bold)
		case .placeholder1:
			return Font.system(size: 44.0, weight: Font.Weight.bold)
		case .placeholder2:
			return Font.system(size: 44.0, weight: Font.Weight.bold)
		case .placeholder3:
			return Font.system(size: 44.0, weight: Font.Weight.bold)
		case .display1:
			return Font.system(size: 44.0, weight: Font.Weight.bold)
		case .display2:
			return Font.system(size: 44.0, weight: Font.Weight.bold)
		case .display3:
			return Font.system(size: 44.0, weight: Font.Weight.bold)
		}
	}
}
