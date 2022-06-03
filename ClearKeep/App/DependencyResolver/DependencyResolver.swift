//
//  DependencyResolver.swift
//  iOSBase
//
//  Created by NamNH on 01/11/2021.
//

import CoreLocation
import Common
import CommonUI
import ChatSecure
import SignalServiceKit

class DependencyResolver {
	static let shared = DependencyResolver()
	
	let fontSet: IFontSet!
	let colorSet: IAppColorSet!
	let imageSet: IAppImageSet!
	
	let securedStoreService: ISecuredStoreService!
	let persistentStoreService: IPersistentStoreService!
	let appTokenService: IAppTokenService!
	
	let locationManager: CLLocationManager!
	let locationService: ILocationService!
	
	let channelStorage: ChannelStorage!
	let authenticationService: IAuthenticationService!
	let socialAuthenticationService: ISocialAuthenticationService!
	let groupService: IGroupService!
	let userService: IUserService!
	let signalStore: ISignalProtocolInMemoryStore!
	let yapDatabaseManager: YapDatabaseManager!
	
	init() {
		fontSet = DefaultFontSet()
		colorSet = ColorSet()
		imageSet = AppImageSet()
		
		// MARK: - CommonUI
		CommonUI.DependencyResolver.shared = CommonUI.DependencyResolver(CommonUIConfig(fontSet: fontSet, colorSet: colorSet, imageSet: imageSet))
		
		// MARK: - Chat Secure
		channelStorage = ChannelStorage(config: ConfigurationProvider.default)
		ChatSecure.DependencyResolver.shared = ChatSecure.DependencyResolver(channelStorage)
		
		// MARK: - Signal
		yapDatabaseManager = YapDatabaseManager(databasePath: ConfigurationProvider.default.yapDatabaseURL)
		signalStore = SignalProtocolInMemoryStore(storage: yapDatabaseManager)
		
		// MARK: - Services
		securedStoreService = SecuredStoreService()
		persistentStoreService = PersistentStoreService()
		appTokenService = AppTokenService(securedStoreService: securedStoreService, persistentStoreService: persistentStoreService)
		authenticationService = CLKAuthenticationService(signalStore: signalStore)
		socialAuthenticationService = SocialAuthenticationService([.facebook,
																   .google(clientId: ConfigurationProvider.default.googleClientId),
																   .office(clientId: ConfigurationProvider.default.officeClientId,
																		   redirectUri: ConfigurationProvider.default.officeRedirectUri)
																  ])
		groupService = GroupService()
		userService = UserService()
		// MARK: - Location
		locationManager = CLLocationManager()
		let locationConfiguration = LocationConfigurations()
		locationService = LocationService(persistentStoreService: persistentStoreService, locationManager: locationManager, configuration: locationConfiguration)
	}
}
