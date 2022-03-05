//
//  CommonUIConfig.swift
//  CommonUI
//
//  Created by NamNH on 01/11/2021.
//

import Common

public struct CommonUIConfig {
	var fontSet: IFontSet
	var colorSet: IColorSet
	var imageSet: ICommonUIImageSet
	
	public init(fontSet: IFontSet, colorSet: IColorSet, imageSet: ICommonUIImageSet) {
		self.fontSet = fontSet
		self.colorSet = colorSet
		self.imageSet = imageSet
	}
}
