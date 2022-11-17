//
//  String+Extensions.swift
//  ClearKeep
//
//  Created by HOANDHTB on 13/07/2022.
//

import Foundation
import CommonCrypto

public extension String {
	fileprivate var emailPredicate: NSPredicate {
		NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}")
	}
	
	var validEmail: Bool {
		self.emailPredicate.evaluate(with: self)
	}
	
	func textFieldValidatorURL() -> Bool {
		if self.count > 20 {
			return false
		}
		
		let urlFormat = "[a-zA-Z0-9@:%._\\+~#=]{2,256}\\.[a-z]{2,6}\\b([-a-zA-Z0-9@:%_\\+.~#?&//=]*)"
		
		let urlPredicate = NSPredicate(format: "SELF MATCHES %@", urlFormat)
		return urlPredicate.evaluate(with: self)
	}
	
	func removingWhitespaces() -> String {
		return components(separatedBy: .whitespaces).joined()
	}
}
