//
//  TwoFactorModel.swift
//  ClearKeep
//
//  Created by đông on 17/03/2022.
//

import UIKit

protocol ITwoFactorModel {
	var id: Int { get }
	var name: String { get }
}

struct TwoFactorModel {
	var id: Int
	var name: String
}

extension TwoFactorModel: ITwoFactorModel {}
