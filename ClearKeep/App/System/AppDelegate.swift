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
import PushKit
import ChatSecure
import AVKit

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {
	
	lazy var systemEventsHandler: SystemEventsHandler? = {
		self.systemEventsHandler(UIApplication.shared)
	}()
	
	func application(_ application: UIApplication, didFinishLaunchingWithOptions
					 launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		FirebaseApp.configure()
		
		// PushKit
		registrationPushRegistry()
		
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

extension AppDelegate: PKPushRegistryDelegate {
	fileprivate func registrationPushRegistry() {
		let voipRegistry: PKPushRegistry = PKPushRegistry(queue: .main)
		
		voipRegistry.delegate = self
		
		voipRegistry.desiredPushTypes = [PKPushType.voIP]
	}
	
	func pushRegistry(_ registry: PKPushRegistry, didUpdate pushCredentials: PKPushCredentials, for type: PKPushType) {
		systemEventsHandler?.handlePushRegistration(pushCredentials: pushCredentials)
	}
	
	func pushRegistry(_ registry: PKPushRegistry, didReceiveIncomingPushWith payload: PKPushPayload, for type: PKPushType, completion: @escaping () -> Void) {
		defer {
			completion()
		}
		
		if type != PKPushType.voIP || DependencyResolver.shared.channelStorage.currentServer?.accessKey.isEmpty ?? false {
			return
		}
		
		guard let notification = payload.dictionaryPayload["publication"] as? [String: Any],
			  let notifiType = notification["notify_type"] as? String else {
			return
		}
		
		if notifiType == "video" {
			CallManager.shared.handleVideoCall(payload: payload)
			return
		}
		
		if notifiType == "busy_request_call" {
			CallManager.shared.handleBusyCall(payload: payload)
			return
		}
		
		if notifiType == "cancel_request_call" {
			guard let roomId = notification["group_id"] as? String else {
				return
			}
			let calls = CallManager.shared.calls.filter { $0.roomId == Int(roomId) ?? 0 }
			calls.forEach { (call) in
				if call.isCallGroup {
					// TODO: handle for group call
					if call.status != .answered {
						CallManager.shared.end(call: call)
					}
				} else {
					CallManager.shared.end(call: call)
				}
			}
			return
		}
		
		CallManager.shared.handleIncomingPushEvent(payload: payload) { _ in
		}
		
		CallManager.shared.endCall = {[weak self] call in
			guard let self = self else { return }
			if call.isCallGroup {
				return
			}
			
			Task {
				await self.systemEventsHandler?.container.interactors.peerCallInteractor.updateVideoCall(groupID: call.roomId, callType: .cancelRequestCall)
			}
		}
	}
}
