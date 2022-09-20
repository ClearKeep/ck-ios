//
//  ProcessInfo+Extension.swift
//  Common
//
//  Created by NamNH on 15/02/2022.
//

import SwiftUI

public extension ProcessInfo {
	var isRunningTests: Bool {
		environment["XCTestConfigurationFilePath"] != nil
	}
}
