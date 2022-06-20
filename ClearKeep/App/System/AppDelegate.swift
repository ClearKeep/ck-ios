//
//  AppDelegate.swift
//  CountriesSwiftUI
//
//  Created by Alexey Naumov on 23.10.2019.
//  Copyright © 2019 Alexey Naumov. All rights reserved.
//

import UIKit
import Combine
import FBSDKCoreKit
import GoogleSignIn
import FirebaseCore
import MSAL

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {
	
	lazy var systemEventsHandler: SystemEventsHandler? = {
		self.systemEventsHandler(UIApplication.shared)
	}()
	
	func application(_ application: UIApplication, didFinishLaunchingWithOptions
					 launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		
		FirebaseApp.configure()
		
		// Facebook
		ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)

		// Office365
		MSALGlobalConfig.loggerConfig.setLogCallback { _, message, containsPII in
			
			// If PiiLoggingEnabled is set YES, this block will potentially contain sensitive information (Personally Identifiable Information), but not all messages will contain it.
			// containsPII == YES indicates if a particular message contains PII.
			// You might want to capture PII only in debug builds, or only if you take necessary actions to handle PII properly according to legal requirements of the region
			if let displayableMessage = message {
				if !containsPII {
					#if DEBUG
					// NB! This sample uses print just for testing purposes
					// You should only ever log to NSLog in debug mode to prevent leaking potentially sensitive information
					print(displayableMessage)
					#endif
				}
			}
		}
		
		// Google
		GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
			if error != nil || user == nil {
				// Show the app's signed-out state.
			} else {
				// Show the app's signed-in state.
			}
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
	
	func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
		// Facebook
		ApplicationDelegate.shared.application(app, open: url, sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplication.OpenURLOptionsKey.annotation])
		
		// Office365
		MSALPublicClientApplication.handleMSALResponse(url, sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String)
		
		// Google
		let handled = GIDSignIn.sharedInstance.handle(url)
		if handled {
			return true
		}
		
		// Handle other custom URL types.
		
		// If not handled by this app, return false.
		return false
	}
}
