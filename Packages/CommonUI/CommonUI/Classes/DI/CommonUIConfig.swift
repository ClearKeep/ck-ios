//
//  CommonUIConfig.swift
//  CommonUI
//
//  Created by NamNH on 01/11/2021.
//

import Common

public struct CommonUIConfig {
	var fontSet: IFontSet
	var colorSet: ICommonUIColorSet
	var imageSet: ICommonUIImageSet
	
	public init(fontSet: IFontSet, colorSet: ICommonUIColorSet, imageSet: ICommonUIImageSet) {
		self.fontSet = fontSet
		self.colorSet = colorSet
		self.imageSet = imageSet
	}
}
