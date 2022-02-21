//
//  AppInfo.swift
//  Common
//
//  Created by NamNH on 30/09/2021.
//

import UIKit
import Foundation

private enum Constants {
	static let appStoreURLFormat = "itms-apps://itunes.apple.com/app/bars/id%@"
}

public class AppInfo {
	// MARK: - Constants
	public static let osName = UIDevice.current.systemName
	public static let osVersion = UIDevice.current.systemVersion
	
	// MARK: - Variables
	public class var appIconBadgeNumber: Int {
		get { return UIApplication.shared.applicationIconBadgeNumber }
		set(value) { UIApplication.shared.applicationIconBadgeNumber = value }
	}
	
	// MARK: - Functions
	public class func getAppVersionString(_ string: String) -> String {
		guard let info = Bundle.main.infoDictionary else {
			return ""
		}
		guard let version = info["CFBundleShortVersionString"] as? String else {
			return ""
		}
		guard let build = info["CFBundleVersion"] as? String else {
			return ""
		}
		
		let appVersion = String(format: string, arguments: [version, build, "", ""])
		return appVersion
	}
	
	public class func getAppStoreURL(_ appStoreId: String) -> URL? {
		return URL(string: String(format: Constants.appStoreURLFormat, appStoreId))
	}
}
