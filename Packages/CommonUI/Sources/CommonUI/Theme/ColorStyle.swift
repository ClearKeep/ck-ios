//
//  ColorStyle.swift
//  CommonUI
//
//  Created by NamNH on 01/11/2021.
//

import UIKit

public protocol IColorSet {
	var neutral: UIColor { get }
	var neutral100: UIColor { get }
	var neutral200: UIColor { get }
	var neutral300: UIColor { get }
	var neutral400: UIColor { get }
	var neutral500: UIColor { get }
	var neutral600: UIColor { get }
	
	var red: UIColor { get }
	var red100: UIColor { get }
	var red600: UIColor { get }
	
	var green: UIColor { get }
	var green100: UIColor { get }
	var green500: UIColor { get }
	
	var yellow: UIColor { get }
	var yellow100: UIColor { get }
	var yellow300: UIColor { get }
	var yellow500: UIColor { get }
	
	var gray: UIColor { get }
	var gray25: UIColor { get }
	var gray50: UIColor { get }
	var gray75: UIColor { get }
	var gray100: UIColor { get }
	var gray150: UIColor { get }
	
	var white: UIColor { get }
	var black: UIColor { get }
	
	var blue: UIColor { get }
	var blue100: UIColor { get }
	var blue200: UIColor { get }
	var blue400: UIColor { get }
	var blue600: UIColor { get }
	var blue700: UIColor { get }
	
	func color(of label: ColorStyle) -> UIColor
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
