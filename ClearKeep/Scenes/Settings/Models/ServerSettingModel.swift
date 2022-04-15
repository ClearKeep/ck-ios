//
//  ServerSettingModel.swift
//  ClearKeep
//
//  Created by đông on 24/03/2022.
//

import Foundation

protocol IServerSettingModel {
	var id: Int { get }
	var name: String { get }
}

struct ServerSettingModel {
	var id: Int
	var name: String
}

extension ServerSettingModel: IServerSettingModel {}
