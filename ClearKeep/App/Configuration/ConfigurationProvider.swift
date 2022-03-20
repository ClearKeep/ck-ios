//
//  ConfigurationProvider.swift
//  ClearKeep
//
//  Created by NamNH on 20/03/2022.
//

import Foundation
import ChatSecure

protocol IConfiguration: IChatSecureConfig {}

enum ConfigurationProvider: IConfiguration {
	case `default`
	
	enum Keys {
		static let clkDomain = "CLK_DOMAIN"
		static let clkPort = "CLK_PORT"
		static let senderDeviceId = "SENDER_DEVICE_ID"
		static let receiverDeviceId = "RECEIVER_DEVICE_ID"
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

}
