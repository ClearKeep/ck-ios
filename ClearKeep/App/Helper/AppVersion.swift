//
//  AppVersion.swift
//  ClearKeep
//
//  Created by NamNH on 31/03/2022.
//

import Foundation

private enum Constants {
	static let dateFormatLocale = "en_US_POSIX"
	static let platform = "IOS"
}

class AppVersion {
	class func getAppVersionString(_ string: String) -> String {
		guard let info = Bundle.main.infoDictionary else {
			return ""
		}
		guard let version = info["CFBundleShortVersionString"] as? String else {
			return ""
		}
		guard let build = info["CFBundleVersion"] as? String else {
			return ""
		}
		
		let date = Date()
		let format = DateFormatter()
		format.dateFormat = "yyyy"
		format.locale = Locale(identifier: Constants.dateFormatLocale)
		let year = format.string(from: date)
		
		guard let yearCopyright = Int(year) else {
			return ""
		}
		
		let appVersion = String(format: string, arguments: [version, build, "", yearCopyright])
		return appVersion
	}
	
	class func getPlatform() -> String {
		return Constants.platform
	}
	
	class func getVersion() -> String {
		guard let info = Bundle.main.infoDictionary else {
			return ""
		}
		guard let version = info["CFBundleShortVersionString"] as? String else {
			return ""
		}
		
		return version
	}
}
