//
//  DependencyResolver.swift
//  ChatSecure
//
//  Created by NamNH on 20/03/2022.
//

import Foundation

public class DependencyResolver {
	public static var shared = DependencyResolver()
	
	var channelStorage: ChannelStorage!
	
	public init(_ channelStorage: ChannelStorage? = nil) {
		self.channelStorage = channelStorage
	}
}

var channelStorage: ChannelStorage { return DependencyResolver.shared.channelStorage }

func commonUIBundle(for aClass: AnyClass) -> Bundle {
	let podBundle = Bundle(for: aClass)
	guard let bundleURL = podBundle.url(forResource: "ChatSecure", withExtension: "bundle"),
		  let bundle = Bundle(url: bundleURL) else {
		assertionFailure("Bundle is nil for \(aClass.description())")
		return Bundle.main
	}
	return bundle
}
