//
//  SwiftUIView.swift
//  
//
//  Created by MinhDev on 24/02/2022.
//

import UIKit
import Foundation
import SwiftUI

public enum IconStyle {
	case standard
	case hover
	case loading
	case disabled

	public var backgroundColorPrimary: UIColor {
		switch self {
		case .standard:
			return commonUIConfig.colorSet.gradientPrimaryLight
		case .hover:
			return commonUIConfig.colorSet.gradientPrimaryDark
		case .loading:
			return commonUIConfig.colorSet.gradientPrimaryLight
		case .disabled:
			return commonUIConfig.colorSet.gradientPrimaryLight.withAlphaComponent(0.4)
		}
	}

	public var BackgroundColorSecondary: UIColor {
		switch self {
		case .standard:
			return commonUIConfig.colorSet.gradientPrimaryLight
		case .hover:
			return commonUIConfig.colorSet.gradientPrimaryDark
		case .loading:
			return commonUIConfig.colorSet.gradientPrimaryLight
		case .disabled:
			return commonUIConfig.colorSet.gradientPrimaryLight.withAlphaComponent(0.4)
		}
	}

	public var borderColor: UIColor {
		switch self {
		case .standard:
			return commonUIConfig.colorSet.gradientPrimaryLight
		case .hover:
			return commonUIConfig.colorSet.gradientPrimaryDark
		case .loading:
			return commonUIConfig.colorSet.gradientPrimaryLight
		case .disabled:
			return commonUIConfig.colorSet.gradientPrimaryLight.withAlphaComponent(0.4)
		}
	}

}
