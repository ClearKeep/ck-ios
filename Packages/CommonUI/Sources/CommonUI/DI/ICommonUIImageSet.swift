//
//  ICommonUIImageSet.swift
//  CommonUI
//
//  Created by NamNH on 01/11/2021.
//

import UIKit

public protocol ICommonUIImageSet: IImageSet {
	var backButton: UIImage { get }
	var searchIcon: UIImage { get }
	var clearTextIcon: UIImage { get }
	var hideSecureTextIcon: UIImage { get }
	var showSecureTextIcon: UIImage { get }
	var radioNonSelectedIcon: UIImage { get }
	var radioSelectedIcon: UIImage { get }
	var errorIcon: UIImage { get }
}
