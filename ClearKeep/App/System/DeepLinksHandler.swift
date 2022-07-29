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
		guard let preAccessToken = getURLComonent(deepLink, queryParameterName: "pre_access_token"),
			  let userName = getURLComonent(deepLink, queryParameterName: "user_name"),
			  let serverDomain = getURLComonent(deepLink, queryParameterName: "server_domain")
		else {
			return
		}
		
		let sceneDelegate = UIApplication.shared.connectedScenes
			   .first?.delegate as? SceneDelegate
		let controller = UIHostingController(rootView: NewPasswordView(preAccessToken: preAccessToken, email: userName, domain: serverDomain))
		controller.modalPresentationStyle = .fullScreen
		sceneDelegate?.window?.rootViewController?.present(controller, animated: true)
	}
	
	func getURLComonent(_ url: URL, queryParameterName: String) -> String? {
		guard let url = URLComponents(string: url.absoluteString) else { return nil }
		return url.queryItems?.first(where: { $0.name == queryParameterName })?.value
	}
}
