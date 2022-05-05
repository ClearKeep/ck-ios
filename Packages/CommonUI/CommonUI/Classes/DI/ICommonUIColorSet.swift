//
//  ICommonUIColorSet.swift
//  CommonUI
//
//  Created by NamNH on 26/04/2022.
//

import SwiftUI
import Common

public protocol ICommonUIColorSet: IColorSet {
	var lightLoading: Color { get }
	var darkLoading: Color { get }
}
