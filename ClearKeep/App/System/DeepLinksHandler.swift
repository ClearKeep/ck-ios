//
//  DeepLinksHandler.swift
//  CountriesSwiftUI
//
//  Created by Alexey Naumov on 26.04.2020.
//  Copyright © 2020 Alexey Naumov. All rights reserved.
//

import Foundation
import SwiftUI

enum DeepLink: Equatable {
	init?(url: URL) {
		return nil
	}
}

// MARK: - DeepLinksHandler

protocol IDeepLinksHandler {
	func open(deepLink: URL)
}

struct DeepLinksHandler: IDeepLinksHandler {
	private let container: DIContainer
	
	init(container: DIContainer) {
		self.container = container
	}
	
	func open(deepLink: URL) {
		let url = deepLink.absoluteString.replacingOccurrences(of: "clearkeep://?", with: "clearkeep://")
		guard let deepLink = URL(string: url) else {
			return
		}
		
		let dictionary = getQueryItems(deepLink.host ?? "")
		print("dictionary: \(dictionary)")
		print("url: \(deepLink.absoluteURL)")
		   print("scheme: \(deepLink.scheme)")
		   print("host: \(deepLink.host)")
		   print("path: \(deepLink.path)")
		   print("components: \(deepLink.pathComponents)")
		let sceneDelegate = UIApplication.shared.connectedScenes
			   .first?.delegate as? SceneDelegate
		let controller = UIHostingController(rootView: NewPasswordView())
		controller.modalPresentationStyle = .fullScreen
		sceneDelegate?.window?.rootViewController?.present(controller, animated: true)
	}
	
	func getQueryItems(_ urlString: String) -> [String : String] {
		var queryItems: [String : String] = [:]
		let components: NSURLComponents? = getURLComonents(urlString)
		for item in components?.queryItems ?? [] {
			queryItems[item.name] = item.value?.removingPercentEncoding
		}
		return queryItems
	}
	
	func getURLComonents(_ urlString: String?) -> NSURLComponents? {
		var components: NSURLComponents? = nil
		let linkUrl = URL(string: urlString?.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? "")
		if let linkUrl = linkUrl {
			components = NSURLComponents(url: linkUrl, resolvingAgainstBaseURL: true)
		}
		return components
	}
}
