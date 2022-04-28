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

struct AppEnvironment {
	let container: DIContainer
	let systemEventsHandler: SystemEventsHandler
}

extension AppEnvironment {
	
	static func bootstrap() -> AppEnvironment {
		let appState = Store<AppState>(AppState())
		let interactors = configuredInteractors(appState: appState)
		let diContainer = DIContainer(appState: appState, interactors: interactors)
		let deepLinksHandler = DeepLinksHandler(container: diContainer)
		let pushNotificationsHandler = PushNotificationsHandler(deepLinksHandler: deepLinksHandler)
		let systemEventsHandler = SystemEventsHandler(
			container: diContainer, deepLinksHandler: deepLinksHandler,
			pushNotificationsHandler: pushNotificationsHandler)
		
		return AppEnvironment(container: diContainer,
							  systemEventsHandler: systemEventsHandler)
	}
	
	private static func configuredInteractors(appState: Store<AppState>) -> DIContainer.Interactors {
		let homeInteractor = HomeInteractor(appState: appState, channelStorage: DependencyResolver.shared.channelStorage)
		let loginInteractor = LoginInteractor(appState: appState, channelStorage: DependencyResolver.shared.channelStorage, socialAuthenticationService: DependencyResolver.shared.socialAuthenticationService, authenticationService: DependencyResolver.shared.authenticationService)
		let registerInteractor = RegisterInteractor(appState: appState, channelStorage: DependencyResolver.shared.channelStorage, authenticationService: DependencyResolver.shared.authenticationService)
		
		return .init(homeInteractor: homeInteractor,
					 loginInteractor: loginInteractor,
					 registerInteractor: registerInteractor)
	}
}

extension DIContainer {
}
