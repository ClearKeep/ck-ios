//
//  IAuthenticationModel.swift
//  Networking
//
//  Created by NamNH on 27/04/2022.
//

import Foundation

public protocol IAuthenticationModel {
	var normalLogin: INormalLoginModel? { get }
	var socialLogin: ISocialLoginModel? { get }
}
