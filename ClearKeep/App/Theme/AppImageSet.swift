//
//  IAppImageSet.swift
//  iOSBase
//
//  Created by NamNH on 02/11/2021.
//

// swiftlint:disable force_unwrapping
import UIKit
import CommonUI

protocol IAppImageSet: IImageSet & ICommonUIImageSet {}

struct AppImageSet: IAppImageSet {
	var splashLogo: UIImage { UIImage(named: "splash_logo")! }
	var logo: UIImage { UIImage(named: "logo")! }
}

extension AppImageSet: ICommonUIImageSet {
	var backButton: UIImage { UIImage() }
	var searchIcon: UIImage { UIImage() }
	var clearTextIcon: UIImage { UIImage() }
	var hideSecureTextIcon: UIImage { UIImage() }
	var showSecureTextIcon: UIImage { UIImage() }
	var radioNonSelectedIcon: UIImage { UIImage() }
	var radioSelectedIcon: UIImage { UIImage() }
	var errorIcon: UIImage { UIImage() }
}
