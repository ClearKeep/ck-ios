//
//  PushNotificationsHandler.swift
//  CountriesSwiftUI
//
//  Created by Alexey Naumov on 26.04.2020.
//  Copyright © 2020 Alexey Naumov. All rights reserved.
//

import UserNotifications
import UIKit
import CommonUI

typealias NotificationPayload = [AnyHashable: Any]

protocol IPushNotificationsHandler { }

class PushNotificationsHandler: NSObject, IPushNotificationsHandler {
	
	private let deepLinksHandler: DeepLinksHandler
	private let container: DIContainer
	
	init(deepLinksHandler: DeepLinksHandler, container: DIContainer) {
		self.deepLinksHandler = deepLinksHandler
		self.container = container
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
		
		self.handleNotification(userInfo: notification.request.content.userInfo, completionHandler: {})
		completionHandler([.banner, .sound, .list])
	}
	
	func userNotificationCenter(_ center: UNUserNotificationCenter,
								didReceive response: UNNotificationResponse,
								withCompletionHandler completionHandler: @escaping () -> Void) {
		let userInfo = response.notification.request.content.userInfo
		print("notification payload: \(userInfo)")
		self.handleNotification(userInfo: userInfo, completionHandler: completionHandler)
	}
	
	func handleNotification(userInfo: [AnyHashable: Any], completionHandler: @escaping () -> Void) {
		if let jsonString = userInfo["publication"] as? String,
		   let jsonData = jsonString.data(using: .utf8) {
			
			if let publicationJson = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any],
			   let deactiveAccountId = publicationJson["deactive_account_id"] as? String {
				handleLogout(deactiveAccountId: deactiveAccountId)
				completionHandler()
				return
			}
			
			if let publicationRemove = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any],
			   let remove = publicationRemove["leave_member"] as? String,
			   let id = DependencyResolver.shared.channelStorage.currentServer?.profile?.userId {
				if remove == id {
				handleAlert()
				}
				return
			}

			if let publicationRemove = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any],
			   let add = publicationRemove["added_member_id"] as? String {
				completionHandler()
				return
			}

			do {
				let publication = try JSONDecoder().decode(PublicationMessageNotification.self, from: jsonData)
				//container.appState[\.authentication.selectedGroupId] = publication.groupId
				completionHandler()
			} catch {
				completionHandler()
			}
			return
		}

		completionHandler()
	}
	
	fileprivate func handleLogout(deactiveAccountId: String) {
		guard let serverLogout = DependencyResolver.shared.channelStorage.getServerWithClientId(clientId: deactiveAccountId) else {
			return
		}
		
		DependencyResolver.shared.channelStorage.removeUser(serverLogout)
		DependencyResolver.shared.channelStorage.removeGroup(serverLogout.serverDomain)
		DependencyResolver.shared.channelStorage.removeServer(serverLogout.serverDomain)
		DependencyResolver.shared.channelStorage.removeProfile(deactiveAccountId)
		let servers = DependencyResolver.shared.channelStorage.getServers(isFirstLoad: false).compactMap({
			ServerModel($0)
		})
		
		if servers.isEmpty {
			DispatchQueue.main.asyncAfter(deadline: .now() + 0.05, execute: {
				let appDelegate = UIApplication.shared.delegate as? AppDelegate
				appDelegate?.systemEventsHandler?.container.appState[\.authentication.servers] = []
			})
			return
		}
		
		if servers.filter({ $0.isActive }).isEmpty {
			DependencyResolver.shared.channelStorage.didSelectServer(servers.last?.serverDomain ?? "")
		}
		
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.05, execute: {
			NotificationCenter.default.post(name: NSNotification.reloadDataHome, object: nil)
		})
	}

	fileprivate func handleAlert() {
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.05, execute: {
			NotificationCenter.default.post(name: NSNotification.alertChat, object: nil)
		})
	}
}
