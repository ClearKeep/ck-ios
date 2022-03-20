//
//  AppDelegate.swift
//  CountriesSwiftUI
//
//  Created by Alexey Naumov on 23.10.2019.
//  Copyright © 2019 Alexey Naumov. All rights reserved.
//

import UIKit
import Combine
import ChatSecure

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {
	
	lazy var systemEventsHandler: SystemEventsHandler? = {
		self.systemEventsHandler(UIApplication.shared)
	}()
	
	func application(_ application: UIApplication, didFinishLaunchingWithOptions
					 launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		
		let clkAuthen = CLKAuthenticationService()
		Task {
//			await clkAuthen.register(displayName: "Test", email: "namnguyen123@gmail.com", password: "123456a@A", domain: "54.235.68.160:25000")
//			await clkAuthen.login(userName: "namnguyen123@gmail.com", password: "123456a@A", domain: "54.235.68.160:25000")
//			await clkAuthen.login(userName: "namnhse02061@gmail.com", password: "123456a@A", domain: "54.235.68.160:25000")
			await clkAuthen.login(userName: "phuong@yopmail.com", password: "123456", domain: "54.235.68.160:15000")
		}

		return true
	}
	
	func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
		systemEventsHandler?.handlePushRegistration(result: .success(deviceToken))
	}
	
	func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
		systemEventsHandler?.handlePushRegistration(result: .failure(error))
	}
	
	func application(_ application: UIApplication,
					 didReceiveRemoteNotification userInfo: NotificationPayload,
					 fetchCompletionHandler completionHandler: @escaping FetchCompletion) {
		systemEventsHandler?
			.appDidReceiveRemoteNotification(payload: userInfo, fetchCompletion: completionHandler)
	}
	
	private func systemEventsHandler(_ application: UIApplication) -> SystemEventsHandler? {
		return sceneDelegate(application)?.systemEventsHandler
	}
	
	private func sceneDelegate(_ application: UIApplication) -> SceneDelegate? {
		return application.windows
			.compactMap({ $0.windowScene?.delegate as? SceneDelegate })
			.first
	}
}
