//
//  ISocialLoginModel.swift
//  Model
//
//  Created by NamNH on 29/04/2022.
//

import Foundation

public protocol ISocialLoginModel {
	var userName: String? { get }
	var userId: String? { get set }
	var requireAction: String? { get }
	var resetPincodeToken: String? { get }
}
