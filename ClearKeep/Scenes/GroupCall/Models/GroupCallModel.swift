//
//  GroupCallModel.swift
//  ClearKeep
//
//  Created by đông on 07/04/2022.
//

import UIKit

protocol IGroupCallModel {
	var id: Int { get }
	var name: String { get }
}

struct GroupCallModel {
	var id: Int
	var name: String
}

extension GroupCallModel: IGroupCallModel {}
