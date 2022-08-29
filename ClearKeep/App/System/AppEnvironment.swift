//
//  AppEnvironment.swift
//  CountriesSwiftUI
//
//  Created by Alexey Naumov on 09.11.2019.
//  Copyright © 2019 Alexey Naumov. All rights reserved.
//

// swiftlint:disable multiline_arguments
import UIKit
import Combine
import Common
import ChatSecure
import CommonUI

struct AppEnvironment {
	let container: DIContainer
	let systemEventsHandler: SystemEventsHandler
}

extension AppEnvironment {
	
	static func bootstrap() -> AppEnvironment {
		let appState = Store<AppState>(AppState())
		appState[\.authentication.servers] = DependencyResolver.shared.channelStorage.getServers(isFirstLoad: true).compactMap { ServerModel($0) }
		let interactors = configuredInteractors(appState: appState)
		let diContainer = DIContainer(appState: appState, interactors: interactors)
		let deepLinksHandler = DeepLinksHandler(container: diContainer)
		let pushNotificationsHandler = PushNotificationsHandler(deepLinksHandler: deepLinksHandler, container: diContainer)
		let systemEventsHandler = SystemEventsHandler(
			container: diContainer, deepLinksHandler: deepLinksHandler,
			pushNotificationsHandler: pushNotificationsHandler)
		
		return AppEnvironment(container: diContainer,
							  systemEventsHandler: systemEventsHandler)
	}
	
	private static func configuredInteractors(appState: Store<AppState>) -> DIContainer.Interactors {
		let homeInteractor = HomeInteractor(appState: appState, channelStorage: DependencyResolver.shared.channelStorage, authenticationService: DependencyResolver.shared.authenticationService, groupService: DependencyResolver.shared.groupService, userService: DependencyResolver.shared.userService, workspaceService: DependencyResolver.shared.workspaceService)
		let loginInteractor = LoginInteractor(appState: appState, channelStorage: DependencyResolver.shared.channelStorage, socialAuthenticationService: DependencyResolver.shared.socialAuthenticationService, authenticationService: DependencyResolver.shared.authenticationService, appTokenService: DependencyResolver.shared.appTokenService)
		let twoFactorInteractor = TwoFactorInteractor(appState: appState, channelStorage: DependencyResolver.shared.channelStorage, userService: DependencyResolver.shared.userService, authService: DependencyResolver.shared.authenticationService)
		let registerInteractor = RegisterInteractor(appState: appState, channelStorage: DependencyResolver.shared.channelStorage, authenticationService: DependencyResolver.shared.authenticationService)
		let socialInteractor = SocialInteractor(appState: appState, channelStorage: DependencyResolver.shared.channelStorage, authenticationService: DependencyResolver.shared.authenticationService, appTokenService: DependencyResolver.shared.appTokenService)
		let fogotPasswordInteractor = FogotPasswordInteractor(appState: appState, channelStorage: DependencyResolver.shared.channelStorage, authenticationService: DependencyResolver.shared.authenticationService)
		let newPasswordInteractor = NewPasswordInteractor(appState: appState, channelStorage: DependencyResolver.shared.channelStorage, authenticationService: DependencyResolver.shared.authenticationService)
		let changePasswordInteractor = ChangePasswordInteractor(appState: appState, channelStorage: DependencyResolver.shared.channelStorage, authenticationService: DependencyResolver.shared.authenticationService, userService: DependencyResolver.shared.userService)
		let chatGroupInteractor = ChatGroupInteractor(appState: appState, channelStorage: DependencyResolver.shared.channelStorage, groupService: DependencyResolver.shared.groupService, userService: DependencyResolver.shared.userService)
		let chatInteractor = ChatInteractor(appState: appState, channelStorage: DependencyResolver.shared.channelStorage, realmManager: DependencyResolver.shared.realmManager, groupService: DependencyResolver.shared.groupService, messageService: DependencyResolver.shared.messageService, uploadFileService: DependencyResolver.shared.uploadFileService, callService: DependencyResolver.shared.callService, clientStore: DependencyResolver.shared.clientStore)
		let createDirectMessageInteractor = CreateDirectMessageInteractor(appState: appState, channelStorage: DependencyResolver.shared.channelStorage, userService: DependencyResolver.shared.userService, groupService: DependencyResolver.shared.groupService)
		let peerCallInteractor = PeerCallInteractor(appState: appState, channelStorage: DependencyResolver.shared.channelStorage, callService: DependencyResolver.shared.callService)
		let groupDetailInteractor = GroupDetailInteractor(appState: appState, groupService: DependencyResolver.shared.groupService, userService: DependencyResolver.shared.userService, channelStorage: DependencyResolver.shared.channelStorage)
		let profileInteractor = ProfileInteractor(appState: appState, channelStorage: DependencyResolver.shared.channelStorage, userService: DependencyResolver.shared.userService)
		let searchInteractor = SearchInteractor(appState: appState, channelStorage: DependencyResolver.shared.channelStorage, groupService: DependencyResolver.shared.groupService, userService: DependencyResolver.shared.userService, messageService: DependencyResolver.shared.messageService, realmManager: DependencyResolver.shared.realmManager)
		let advancedSeverInteractor = AdvancedSeverInteractor(appState: appState, channelStorage: DependencyResolver.shared.channelStorage, workspaceService: DependencyResolver.shared.workspaceService)
		let settingServerInteractor = SettingServerInteractor(channelStorage: DependencyResolver.shared.channelStorage)
		let notificationInteractor = NotificationInteractor(appState: appState, channelStorage: DependencyResolver.shared.channelStorage)

		return .init(homeInteractor: homeInteractor,
					 loginInteractor: loginInteractor,
					 twoFactorInteractor: twoFactorInteractor,
					 registerInteractor: registerInteractor,
					 socialInteractor: socialInteractor,
					 fogotPasswordInteractor: fogotPasswordInteractor,
					 newPasswordInteractor: newPasswordInteractor,
					 changePasswordInteractor: changePasswordInteractor,
					 chatGroupInteractor: chatGroupInteractor,
					 chatInteractor: chatInteractor,
					 createDirectMessageInteractor: createDirectMessageInteractor,
					 groupDetailInteractor: groupDetailInteractor,
					 peerCallInteractor: peerCallInteractor,
					 profileInteractor: profileInteractor,
					 searchInteractor: searchInteractor,
					 advancedSeverInteractor: advancedSeverInteractor,
					 settingServerInteractor: settingServerInteractor,
					 notificationInteractor: notificationInteractor)
	}
}

extension DIContainer {
}
