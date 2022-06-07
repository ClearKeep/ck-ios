//
//  CallModel.swift
//  ClearKeep
//
//  Created by đông on 09/05/2022.
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
