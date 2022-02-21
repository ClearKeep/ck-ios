//
//  TextStyle.swift
//  CommonUI
//
//  Created by NamNH on 01/11/2021.
//

import Foundation
import UIKit

public protocol ITextStyle {
	var font: UIFont { get }
	var weight: String { get }
	var size: CGFloat { get }
}

public enum TextStyle: ITextStyle {
	case header1
	case header2
	case header3
	case header4
	case header5
	case header6
	case header7
	case bodyL
	case bodyM
	case bodyS
	case bodyXS
	case bodyXXS
	case textL
	case textM
	case textS
	case textXS
	case textXXS
	
	enum Weight: String {
		case regular = "Regular"
		case medium = "Medium"
		case bold = "Bold"
	}
	
	public var font: UIFont {
		let fontName = "Inter"
		let fullFontName = "\(fontName)-\(self.weight)"
		return UIFont(name: fullFontName, size: self.size) ?? UIFont.systemFont(ofSize: self.size)
	}
	
	public var weight: String {
		switch self {
		case .header1, .header2, .header3, .header4, .header5, .header6, .header7:
			return Weight.bold.rawValue
		case .bodyL, .bodyM, .bodyS, .bodyXS, .bodyXXS:
			return Weight.medium.rawValue
		case .textL, .textM, .textS, .textXS, .textXXS:
			return Weight.regular.rawValue
		}
	}
	
	public var size: CGFloat {
		switch self {
		case .header1:
			return 44.0
		case .header2:
			return 36.0
		case .header3:
			return 28.0
		case .header4:
			return 18.0
		case .header5:
			return 16.0
		case .header6:
			return 14.0
		case .header7:
			return 12.0
		case .bodyL:
			return 16.0
		case .bodyM:
			return 14.0
		case .bodyS:
			return 12.0
		case .bodyXS:
			return 8.0
		case .bodyXXS:
			return 8.0
		case .textL:
			return 16.0
		case .textM:
			return 14.0
		case .textS:
			return 12.0
		case .textXS:
			return 10.0
		case .textXXS:
			return 10.0
		}
	}
}
