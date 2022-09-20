//
//  ServerSettingModel.swift
//  ClearKeep
//
//  Created by đông on 24/03/2022.
//

import Foundation

protocol IServerSettingModel {
	var url: String { get set }
	var name: String { get set }
}

struct ServerSettingModel: IServerSettingModel {
	var url: String = ""
	var name: String = ""
}
