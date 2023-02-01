//
//  DeviceExtensions.swift
//  Common
//
//  Created by Eddie on 01/02/2023.
//
//  Ref: https://stackoverflow.com/a/73947451/1696598

import Foundation

public extension UIDevice {
	var hasDynamicIsland: Bool {
		if let simulatorModelIdentifier = ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] {
			let nameSimulator = simulatorModelIdentifier
			return nameSimulator == "iPhone15,2" || nameSimulator == "iPhone15,3" ? true : false
		}

		var sysinfo = utsname()
		uname(&sysinfo) // ignore return value
		let name =  String(bytes: Data(bytes: &sysinfo.machine, count: Int(_SYS_NAMELEN)), encoding: .ascii)!.trimmingCharacters(in: .controlCharacters)
		return name == "iPhone15,2" || name == "iPhone15,3" ? true : false
	}
}
