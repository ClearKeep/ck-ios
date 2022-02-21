//
//  SampleResponse.swift
//  iOSBase
//
//  Created by NamNH on 05/10/2021.
//

import Foundation

struct SampleResponse: Codable {
	var status: Int?
	var message: String?
	var data: [SampleDataResponse]?
}

struct SampleDataResponse: Codable {
	var id: Int
	var name: String
}

extension SampleModel {
	init(item: SampleDataResponse) {
		id = item.id
		name = item.name
	}
}
