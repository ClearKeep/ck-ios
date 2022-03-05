//
//  IAppImageSet.swift
//  iOSBase
//
//  Created by NamNH on 02/11/2021.
//

import SwiftUI
import CommonUI

protocol IAppImageSet: IImageSet & ICommonUIImageSet {}

struct AppImageSet: IAppImageSet {
	var splashLogo: Image { Image("splash_logo") }
	var logo: Image { Image("logo") }
}

extension AppImageSet: ICommonUIImageSet {
	var searchIcon: Image { Image("ic_search") }
	var eyeOn: Image { Image("ic_eye_on") }
	var eyeOff: Image { Image("ic_eye_off") }
}
