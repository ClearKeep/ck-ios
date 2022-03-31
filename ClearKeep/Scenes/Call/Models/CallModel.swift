//
//  CallModel.swift
//  ClearKeep
//
//  Created by đông on 31/03/2022.
//

import UIKit

protocol ICallModel {
	var id: Int { get }
	var name: String { get }
}

struct CallModel {
	var id: Int
	var name: String
}

extension CallModel: ICallModel {}
