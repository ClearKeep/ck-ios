//
//  ILoginModel.swift
//  ClearKeep
//
//  Created by đông on 08/03/2022.
//

import Foundation
protocol ILoginModel {
	var id: Int { get }
	var email: String { get }
	var password: String { get }
}

struct LoginModel {
	var id: Int
	var name: String
	var password: String
}

extension SampleModel: ILoginModel {
	var email: String {
		return "email"
	}

	var password: String {
		return "password"
	}
}
