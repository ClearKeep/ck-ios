//
//  DependencyResolver.swift
//  CommonUI
//
//  Created by NamNH on 01/11/2021.
//

import Foundation

public class DependencyResolver {
	public static var shared = DependencyResolver()
	
	var commonUIConfig: CommonUIConfig!
	
	public init(_ commonUIConfig: CommonUIConfig? = nil) {
		self.commonUIConfig = commonUIConfig
	}
}

var commonUIConfig: CommonUIConfig { return DependencyResolver.shared.commonUIConfig }

public extension Bundle {
	static func commonUIBundle(for aClass: AnyClass) -> Bundle {
		let podBundle = Bundle(for: aClass)
		guard let bundleURL = podBundle.url(forResource: "CommonUI", withExtension: "bundle"),
			  let bundle = Bundle(url: bundleURL) else {
				  assertionFailure("Bundle is nil for \(aClass.description())")
				  return Bundle.main
			  }
		return bundle
	}
}
