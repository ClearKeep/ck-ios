//
//  IMovieAPIService.swift
//  Model
//
//  Created by NamNH on 30/09/2021.
//

import UIKit

public extension String {
	var int: Int? {
		return Int(self)
	}
	
	var float: Float? {
		return Float(self)
	}
	
	var url: URL? {
		return URL(string: self)
	}
	
	var image: UIImage? {
		return UIImage(named: self)
	}
	
	var localized: String {
		var result = Bundle.main.localizedString(forKey: self, value: nil, table: nil)
		
		if result == self {
			result = Bundle.main.localizedString(forKey: self, value: nil, table: "Localize")
		}
		return result
	}
	
	var asciiArray: [UInt32] {
		return unicodeScalars.filter { $0.isASCII }.map { $0.value }
	}
	
	func hashCode() -> Int32 {
		var hash: Int32 = 0
		for index in self.asciiArray {
			hash = 31 &* hash &+ Int32(index)
		}
		return hash
	}
}
