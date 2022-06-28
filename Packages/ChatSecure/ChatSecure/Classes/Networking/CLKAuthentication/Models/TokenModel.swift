//
//  TokenModel.swift
//  Pods
//
//  Created by Quang Pham on 30/06/2022.
//

import Model

public struct TokenModel: ITokenModel {
	public var accessKey: String
	public var refreshToken: String
	
	public init(accessKey: String, refreshToken: String) {
		self.accessKey = accessKey
		self.refreshToken = refreshToken
	}
}
