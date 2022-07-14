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
}
