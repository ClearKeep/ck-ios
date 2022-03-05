//
//  ICommonUIImageSet.swift
//  CommonUI
//
//  Created by NamNH on 01/11/2021.
//

import SwiftUI

public protocol ICommonUIImageSet: IImageSet {
	var searchIcon: Image { get }
	var userIcon: Image { get }
	var mailIcon: Image { get }
	var lockIcon: Image { get }
	var eyeIcon: Image { get }
	var eyeCrossIcon: Image { get }
	var googleIcon: Image { get }
	var facebookIcon: Image { get }
	var officeIcon: Image { get }
}
