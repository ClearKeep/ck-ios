//
//  IHomeModels.swift
//  Model
//
//  Created by MinhDev on 02/06/2022.
//

import Foundation

public protocol IHomeModels {
	var groupModel: [IGroupModel]? { get }
	var userModel: IUser? { get }
	var members: [IUser]? { get }
}
