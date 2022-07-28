//
//  SystemEventsHandler.swift
//  CountriesSwiftUI
//
//  Created by Alexey Naumov on 27.10.2019.
//  Copyright © 2019 Alexey Naumov. All rights reserved.
//

import UIKit
import Common
import Combine

typealias FetchCompletion = (UIBackgroundFetchResult) -> Void

protocol ISystemEventsHandler {
	func sceneOpenURLContexts(_ urlContexts: Set<UIOpenURLContext>)
	func sceneDidBecomeActive()
	func sceneWillResignActive()
	func handlePushRegistration(result: Result<Data, Error>)
	func appDidReceiveRemoteNotification(payload: NotificationPayload,
										 fetchCompletion: @escaping FetchCompletion)
}

struct SystemEventsHandler: ISystemEventsHandler {
	
	let container: DIContainer
	let deepLinksHandler: DeepLinksHandler
	let pushNotificationsHandler: PushNotificationsHandler
	private var cancelBag = CancelBag()
	
	init(container: DIContainer,
		 deepLinksHandler: DeepLinksHandler,
		 pushNotificationsHandler: PushNotificationsHandler) {
		
		self.container = container
		self.deepLinksHandler = deepLinksHandler
		self.pushNotificationsHandler = pushNotificationsHandler
		
		installKeyboardHeightObserver()
		installPushNotificationsSubscriberOnLaunch()
	}
	
	private func installKeyboardHeightObserver() {
		let appState = container.appState
		NotificationCenter.default.keyboardHeightPublisher
			.sink { [appState] height in
				appState[\.system.keyboardHeight] = height
			}
			.store(in: cancelBag)
	}
	
	private func installPushNotificationsSubscriberOnLaunch() {
		UNUserNotificationCenter.current()
			.requestAuthorization(
				options: [.alert, .sound, .badge]) { granted, _ in
					print("Permission granted: \(granted)")
					guard granted else { return }
					DispatchQueue.main.async {
						UIApplication.shared.registerForRemoteNotifications()
					}
					
				}
	}
	
	func sceneOpenURLContexts(_ urlContexts: Set<UIOpenURLContext>) {
		guard let url = urlContexts.first?.url else { return }
		deepLinksHandler.open(deepLink: url)
	}
	
	func sceneDidBecomeActive() {
		container.appState[\.system.isActive] = true
	}
	
	func sceneWillResignActive() {
		container.appState[\.system.isActive] = false
	}
	
	func handlePushRegistration(result: Result<Data, Error>) {
		switch result {
		case .success(let token):
			container.interactors.homeInteractor.registerToken(token)
		case .failure(let error):
			print(error)
		}
	}
	
	func appDidReceiveRemoteNotification(payload: NotificationPayload,
										 fetchCompletion: @escaping FetchCompletion) {
	}
}

// MARK: - Notifications

private extension NotificationCenter {
	var keyboardHeightPublisher: AnyPublisher<CGFloat, Never> {
		let willShow = publisher(for: UIApplication.keyboardWillShowNotification)
			.map { $0.keyboardHeight }
		let willHide = publisher(for: UIApplication.keyboardWillHideNotification)
			.map { _ in CGFloat(0) }
		return Publishers.Merge(willShow, willHide)
			.eraseToAnyPublisher()
	}
}

private extension Notification {
	var keyboardHeight: CGFloat {
		return (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?
			.cgRectValue.height ?? 0
	}
}
