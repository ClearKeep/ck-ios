//
//  SceneDelegate.swift
//  CountriesSwiftUI
//
//  Created by Alexey Naumov on 23.10.2019.
//  Copyright © 2019 Alexey Naumov. All rights reserved.
//

// swiftlint:disable multiline_parameters

import UIKit
import SwiftUI
import Combine
import Foundation
import ChatSecure
import FBSDKLoginKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
	
	var window: UIWindow?
	var systemEventsHandler: SystemEventsHandler?
	
	func scene(_ scene: UIScene, willConnectTo session: UISceneSession,
			   options connectionOptions: UIScene.ConnectionOptions) {
		let environment = AppEnvironment.bootstrap()
		
		let contentView = RootView(container: environment.container)
		if let windowScene = scene as? UIWindowScene {
			let window = UIWindow(windowScene: windowScene)
			window.rootViewController = UIHostingController(rootView: contentView)
			self.window = window
			window.makeKeyAndVisible()
		}
		self.systemEventsHandler = environment.systemEventsHandler
		if !connectionOptions.urlContexts.isEmpty {
			systemEventsHandler?.sceneOpenURLContexts(connectionOptions.urlContexts)
		}
	}
	
	func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
		guard let url = URLContexts.first?.url else {
			return
		}
		systemEventsHandler?.sceneOpenURLContexts(URLContexts)

		// Facebook login redirect
		ApplicationDelegate.shared.application(
			UIApplication.shared,
			open: url,
			sourceApplication: nil,
			annotation: [UIApplication.OpenURLOptionsKey.annotation])
	}
	
	func sceneDidBecomeActive(_ scene: UIScene) {
		systemEventsHandler?.sceneDidBecomeActive()
	}
	
	func sceneWillResignActive(_ scene: UIScene) {
		systemEventsHandler?.sceneWillResignActive()
	}
}
