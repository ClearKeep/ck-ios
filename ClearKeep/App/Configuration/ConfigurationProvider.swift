//
//  ConfigurationProvider.swift
//  ClearKeep
//
//  Created by NamNH on 20/03/2022.
//

import Foundation
import Model

protocol IConfiguration: IChatSecureConfig {}

enum ConfigurationProvider: IConfiguration {
	case `default`
	
	enum Keys {
		static let clkDomain = "CLK_DOMAIN"
		static let clkPort = "CLK_PORT"
		static let senderDeviceId = "SENDER_DEVICE_ID"
		static let receiverDeviceId = "RECEIVER_DEVICE_ID"
		static let googleClientId = "GOOGLE_CLIENT_ID"
		static let officeClientId = "OFFICE_CLIENT_ID"
		static let officeRedirectUri = "OFFICE_REDIRECT_URI"
		static let databaseDebug = "DATABASE_DEBUG"
		static let databasePath = "DATABASE_PATH"
		static let appGroupName = "APP_GROUP_NAME"
		static let yapDatabasePath = "YAP_DATABASE_PATH"
	}
	
	var clkDomain: String {
		Configuration.value(for: Keys.clkDomain)
	}
	
	var clkPort: String {
		Configuration.value(for: Keys.clkPort)
	}
	
	var senderDeviceId: Int {
		Configuration.value(for: Keys.senderDeviceId)
	}
	
	var receiverDeviceId: Int {
		Configuration.value(for: Keys.receiverDeviceId)
	}

	var googleClientId: String {
		Configuration.value(for: Keys.googleClientId)
	}
	
	var officeClientId: String {
		Configuration.value(for: Keys.officeClientId)
	}
	
	var officeRedirectUri: String {
		Configuration.value(for: Keys.officeRedirectUri)
	}
	
	var dataBaseDebug: String {
		// Configuration.value(for: Keys.databaseDebug)
		"false"
	}
	
	var databaseURL: URL? {
		if dataBaseDebug == "true" {
			let paths = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true)
			let baseDir = paths.count > 0 ? paths[0] : NSTemporaryDirectory()
			return URL(fileURLWithPath: baseDir).appendingPathComponent("qa.db")
		}
		
		let sharedDirectoryURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.telred.clearkeep.qa")
		return sharedDirectoryURL?.appendingPathComponent("qa.db")
	}
	
	var yapDatabaseURL: URL {
		let paths = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true)
		let baseDir = paths.count > 0 ? paths[0] : NSTemporaryDirectory()
		return URL(fileURLWithPath: baseDir).appendingPathComponent(Configuration.value(for: Keys.yapDatabasePath))
	}
}
