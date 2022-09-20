//
//  ICommonUIImageSet.swift
//  CommonUI
//
//  Created by NamNH on 01/11/2021.
//

import SwiftUI

public protocol ICommonUIImageSet: IImageSet {
	var searchIcon: Image { get }
	var eyeOn: Image { get }
	var eyeOff: Image { get }
	var closeIcon: Image { get }
	var userIcon: Image { get }
	var mailIcon: Image { get }
	var lockIcon: Image { get }
}
