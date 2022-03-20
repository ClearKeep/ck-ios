//
//  AppTheme.swift
//  ClearKeep
//
//  Created by NamNH on 01/03/2022.
//

import UIKit
import CommonUI

struct AppTheme {
	// MARK: - Singleton
	static let shared = AppTheme()
	
	// MARK: - Variables
	let fontSet: IFontSet!
	let colorSet: IColorSet!
	let imageSet: IAppImageSet!
	
	// MARK: - Init
	private init() {
		fontSet = DefaultFontSet()
		colorSet = ColorSet()
		imageSet = AppImageSet()
	}
}
