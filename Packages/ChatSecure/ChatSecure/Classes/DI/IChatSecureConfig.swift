//
//  IChatSecureConfig.swift
//  ChatSecure
//
//  Created by NamNH on 20/03/2022.
//

import UIKit

public protocol IChatSecureConfig {
	var clkDomain: String { get }
	var clkPort: String { get }
	var senderDeviceId: Int { get }
	var receiverDeviceId: Int { get }
}
