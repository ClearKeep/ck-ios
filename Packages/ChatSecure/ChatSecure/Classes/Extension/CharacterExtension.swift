//
//  CharacterExtension.swift
//  ChatSecure
//
//  Created by NamNH on 20/03/2022.
//

import Foundation

private extension Character {
	var asciiValue: UInt32? {
		return String(self).unicodeScalars.filter { $0.isASCII }.first?.value
	}
}
