//
//  IAPIConfigurations.swift
//  Networking
//
//  Created by NamNH on 02/10/2021.
//

import Foundation

public protocol IAPIConfigurations {
	var apiKey: String { get }
	var endpoint: URL { get }
}
