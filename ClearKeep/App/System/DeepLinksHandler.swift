//
//  DeepLinksHandler.swift
//  CountriesSwiftUI
//
//  Created by Alexey Naumov on 26.04.2020.
//  Copyright © 2020 Alexey Naumov. All rights reserved.
//

import Foundation

enum DeepLink: Equatable {
	init?(url: URL) {
		return nil
	}
}

// MARK: - DeepLinksHandler

protocol IDeepLinksHandler {
	func open(deepLink: DeepLink)
}

struct DeepLinksHandler: IDeepLinksHandler {
	private let container: DIContainer
	
	init(container: DIContainer) {
		self.container = container
	}
	
	func open(deepLink: DeepLink) {
	}
}
