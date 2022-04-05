//
//  TwoFactorModel.swift
//  ClearKeep
//
//  Created by đông on 23/03/2022.
//

import Foundation

protocol ITwoFactorModel {
	var id: Int { get }
	var name: String { get }
}

struct TwoFactorModel {
	var id: Int
	var name: String
}

extension TwoFactorModel: ITwoFactorModel {}
