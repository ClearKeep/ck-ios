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
import SocialAuthentication

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
	let messageService: IMessageService!
	let uploadFileService: IUploadFileService!
	let callService: ICallService
	let signalStore: ISignalProtocolInMemoryStore!
	let yapDatabaseManager: YapDatabaseManager!
	let realmManager: RealmManager!
	let workspaceService: IWorkspaceService
	let clientStore: ClientStore
	
	init() {
		fontSet = DefaultFontSet()
		colorSet = ColorSet()
		imageSet = AppImageSet()
		securedStoreService = SecuredStoreService()
		persistentStoreService = PersistentStoreService()
		
		clientStore = ClientStore(persistentStoreService: persistentStoreService, securedStoreService: securedStoreService)
		
		// MARK: - CommonUI
		CommonUI.DependencyResolver.shared = CommonUI.DependencyResolver(CommonUIConfig(fontSet: fontSet, colorSet: colorSet, imageSet: imageSet))
		
		// MARK: - Chat Secure
		realmManager = RealmManager(databasePath: ConfigurationProvider.default.databaseURL)
		channelStorage = ChannelStorage(config: ConfigurationProvider.default, clientStore: clientStore, realmManager: realmManager)
		
		// MARK: - Signal
		yapDatabaseManager = YapDatabaseManager(databasePath: ConfigurationProvider.default.yapDatabaseURL)
		signalStore = SignalProtocolInMemoryStore(storage: yapDatabaseManager, channelStorage: channelStorage)
		
		// MARK: - Services
		appTokenService = AppTokenService(securedStoreService: securedStoreService, persistentStoreService: persistentStoreService)
		let senderStore = SenderKeyInMemoryStore(storage: yapDatabaseManager, channelStorage: channelStorage)
		authenticationService = CLKAuthenticationService(signalStore: signalStore, clientStore: clientStore, senderKeyStore: senderStore)
		messageService = MessageService(clientStore: clientStore, signalStore: signalStore, senderStore: senderStore, channelStorage: channelStorage)
		socialAuthenticationService = SocialAuthenticationService([.facebook,
																   .google(clientId: ConfigurationProvider.default.googleClientId),
																   .office(clientId: ConfigurationProvider.default.officeClientId,
																		   redirectUri: ConfigurationProvider.default.officeRedirectUri)
																  ])
		groupService = GroupService(senderStore: senderStore, signalStore: signalStore)
		userService = UserService(signalStore: signalStore)
		uploadFileService = UploadFileService()
		callService = CallService()
		workspaceService = WorkspaceService()
		ChatSecure.DependencyResolver.shared = ChatSecure.DependencyResolver(channelStorage)
		// MARK: - Location
		locationManager = CLLocationManager()
		let locationConfiguration = LocationConfigurations()
		locationService = LocationService(persistentStoreService: persistentStoreService, locationManager: locationManager, configuration: locationConfiguration)
	}
}
