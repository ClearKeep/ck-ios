//
//  IRegisterModel.swift
//  ClearKeep
//
//  Created by MinhDev on 07/03/2022.
//

import Foundation
protocol IRegisterModel {
	var id: Int { get }
	var name: String { get }
}

struct RegisterModel {
	var id: Int
	var name: String
}

extension SampleModel: IRegisterModel {}
