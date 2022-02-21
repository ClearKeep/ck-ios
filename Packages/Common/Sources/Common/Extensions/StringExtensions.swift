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
		let languageCode = Locale.current.languageCode

		guard let bundlePath = Bundle.main.path(forResource: languageCode, ofType: "lproj") else {
			return self
		}
		
		guard let bundle = Bundle.init(path: bundlePath) else {
			return self
		}
		
		var result = bundle.localizedString(forKey: self, value: nil, table: nil)
		
		if result == self {
			result = bundle.localizedString(forKey: self, value: nil, table: "Commerce")
		}
		return result
	}
}
