//
//  CountryCodeModel.swift
//  ClearKeep
//
//  Created by đông on 19/05/2022.
//

import Foundation

struct CountryCodeJSON: Codable, Identifiable {
	enum CodingKeys: CodingKey {
		case name
		case code
		case abbreviation
	}
	var id = UUID()
	var name: String
	var code: String
	var abbreviation: String
}

class ReadData: ObservableObject {
	@Published var countryCodes = [CountryCodeJSON]()

	init() {
		loadData()
	}

	func loadData() {
		guard let url = Bundle.main.url(forResource: "locations", withExtension: "json")
			else {
				print("Json file not found")
				return
			}
		let data = (try? Data(contentsOf: url)) ?? Data()
		let countryCodes = try? JSONDecoder().decode([CountryCodeJSON].self, from: data)
		self.countryCodes = countryCodes ?? []
	}
}
