//
//  Debug.swift
//  Common
//
//  Created by NamNH on 20/04/2022.
//

import Foundation

public struct Debug {
	/// Print information
	/// - Parameters:
	///   - message: Message of log
	///   - object: Object to log
	///   - function: Function's name
	///   - line: Line number of function
	static public func DLog(_ message: String, _ object: Any? = nil, function: String = #function, line: Int = #line) {
#if DEBUG
		print("- [", function, "] - [ LINE", line, "] -", message, object == nil ? "" : object as Any)
#endif
	}
}
