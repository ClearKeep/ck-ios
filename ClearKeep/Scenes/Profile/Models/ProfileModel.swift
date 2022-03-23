//
//  ProfileModel.swift
//  ClearKeep
//
//  Created by đông on 10/03/2022.
//

import UIKit

protocol IProfileModel {
	var id: Int { get }
	var name: String { get }
}

struct ProfileModel {
	var id: Int
	var name: String
}

extension ProfileModel: IProfileModel {}
