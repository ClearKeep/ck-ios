//
//  SocialModel.swift
//  ClearKeep
//
//  Created by đông on 08/03/2022.
//

import UIKit

protocol ISocialModel {
	var id: Int { get }
	var name: String { get }
}

struct SocialModel {
	var id: Int
	var name: String
}

extension SocialModel: ISocialModel {}
