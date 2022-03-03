//
//  File.swift
//
//
//  Created by đông on 26/02/2022.
//

import SwiftUI
import UIKit
import Foundation

private enum Constants {
	static let cornerRadius: CGFloat = 12.0
}

public enum TextFieldStyle {
	case light, dark
	case error, errorDark

	public var backgroundColor: UIColor {
			switch self {
			case .light:
				return commonUIConfig.colorSet.gray5
			case .dark:
				return commonUIConfig.colorSet.gray5Dark
			case .error:
				return commonUIConfig.colorSet.errorLight
			case .errorDark:
				return commonUIConfig.colorSet.errorDark
			}
		}
}
