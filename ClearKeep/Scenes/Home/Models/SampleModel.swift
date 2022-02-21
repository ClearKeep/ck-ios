//
//  SampleModel.swift
//  iOSBase
//
//  Created by NamNH on 05/10/2021.
//

import UIKit

protocol ISampleModel {
	var id: Int { get }
	var name: String { get }
}

struct SampleModel {
	var id: Int
	var name: String
}

extension SampleModel: ISampleModel {}
