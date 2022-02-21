//
//  PushNotificationsHandler.swift
//  CountriesSwiftUI
//
//  Created by Alexey Naumov on 26.04.2020.
//  Copyright © 2020 Alexey Naumov. All rights reserved.
//

import UserNotifications

typealias NotificationPayload = [AnyHashable: Any]

protocol IPushNotificationsHandler { }

class PushNotificationsHandler: NSObject, IPushNotificationsHandler {
	
	private let deepLinksHandler: DeepLinksHandler
	
	init(deepLinksHandler: DeepLinksHandler) {
		self.deepLinksHandler = deepLinksHandler
		super.init()
		UNUserNotificationCenter.current().delegate = self
	}
}

// MARK: - UNUserNotificationCenterDelegate

extension PushNotificationsHandler: UNUserNotificationCenterDelegate {
	
	func userNotificationCenter(_ center: UNUserNotificationCenter,
								willPresent notification: UNNotification,
								withCompletionHandler completionHandler:
								@escaping (UNNotificationPresentationOptions) -> Void) {
		completionHandler([.banner, .sound, .list])
	}
	
	func userNotificationCenter(_ center: UNUserNotificationCenter,
								didReceive response: UNNotificationResponse,
								withCompletionHandler completionHandler: @escaping () -> Void) {
		let userInfo = response.notification.request.content.userInfo
		handleNotification(userInfo: userInfo, completionHandler: completionHandler)
	}
	
	func handleNotification(userInfo: [AnyHashable: Any], completionHandler: @escaping () -> Void) {
		guard let payload = userInfo["aps"] as? NotificationPayload else {
			completionHandler()
			return
		}
		print(payload)
		//        deepLinksHandler.open(deepLink: .showCountryFlag(alpha3Code: countryCode))
		completionHandler()
	}
}
