//
//  FontSet.swift
//  CommonUI
//
//  Created by NamNH on 01/11/2021.
//

import SwiftUI

public protocol IFontSet {
	func font(style: FontStyle) -> Font
}

public enum FontStyle {
	case heading1
	case heading2
	case heading3

	case body1
	case body2
	case body3
	
	case input1
	case input2
	case input3
	
	case placeholder1
	case placeholder2
	case placeholder3

	case display1
	case display2
	case display3
}
