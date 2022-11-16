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

public enum PasswordType {
	
	case strong
	case soft
	case weak
	case errorPassword
}

/// Private properties
private let capitalLetters = "QWEÉRTYUÚIÍOÓPAÁSDFGHJKLÑZXCVBNM"
private let lowercasedLetters = "qweértyuúiíoópaásdfghjklñzxcvbnm"
private let numbers = "0987654321"
private let specialLetter = "!@#$%&_-"

class ValidatePasswords: NSObject {
	
	class func getLevelPasswordFullRegEx(_ password: String,
										 _ minimumCharacters: Int) -> PasswordType {
		var rules: Int = 0
		var characterSet: CharacterSet!
		
		characterSet = CharacterSet(charactersIn: capitalLetters)
		if password.rangeOfCharacter(from: characterSet) != nil {
			rules += 1
		}
		
		characterSet = CharacterSet(charactersIn: lowercasedLetters)
		if password.rangeOfCharacter(from: characterSet) != nil {
			rules += 1
		}
		
		characterSet = CharacterSet(charactersIn: numbers)
		if password.rangeOfCharacter(from: characterSet) != nil {
			rules += 1
		}
		
		characterSet = CharacterSet(charactersIn: specialLetter)
		if password.rangeOfCharacter(from: characterSet) != nil {
			rules += 1
		}
		
		switch rules {
		case 0:
			return PasswordType.errorPassword
		case 1:
			return PasswordType.weak
		case 2:
			return PasswordType.weak
		case 3:
			return PasswordType.soft
		case 4:
			return PasswordType.strong
		default:
			return PasswordType.strong
		}
	}
}
