//
//  IFontSet.swift
//  CommonUI
//
//  Created by NamNH on 01/11/2021.
//

import UIKit

public protocol IFontSet {
	func font(style: FontStyle) -> UIFont
}

public enum FontStyle {
	case displayL
	case displayM
	case displayS

	case displayLB
	case displayMB
	case displaySB
	
	case textL
	case textM
	case textS
	case textXS
	case linkL
	case linkM
	case linkS
	case linkXS
}
