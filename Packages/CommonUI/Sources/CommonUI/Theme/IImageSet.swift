//
//  IImageSet.swift
//  CommonUI
//
//  Created by NamNH on 01/11/2021.
//

import SwiftUI

public protocol IImageSet {
	var splashLogo: Image { get }
	var logo: Image { get }
	var searchIcon: Image { get }
	var eyeOn: Image { get }
	var eyeOff: Image { get }
	var userIcon: Image { get }
	var mailIcon: Image { get }
	var lockIcon: Image { get }
}
