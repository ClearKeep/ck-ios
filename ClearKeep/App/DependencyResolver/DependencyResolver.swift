//
//  DependencyResolver.swift
//  iOSBase
//
//  Created by NamNH on 01/11/2021.
//

import CoreLocation
import Common
import CommonUI
import Networking

class DependencyResolver {
	static let shared = DependencyResolver()
	
	let fontSet: IFontSet!
	let colorSet: IColorSet!
	let imageSet: IAppImageSet!
	
	let securedStoreService: ISecuredStoreService!
	let persistentStoreService: IPersistentStoreService!
	let appTokenService: IAppTokenService!
	
	let locationManager: CLLocationManager!
	let locationService: ILocationService!
	
	let sampleAPIService: APIService!
	
	init() {
		fontSet = DefaultFontSet()
		colorSet = ColorSet()
		imageSet = AppImageSet()
		
		// MARK: - CommonUI
		CommonUI.DependencyResolver.shared = CommonUI.DependencyResolver(CommonUIConfig(fontSet: fontSet, colorSet: colorSet, imageSet: imageSet))
		
		// MARK: - Services
		securedStoreService = SecuredStoreService()
		persistentStoreService = PersistentStoreService()
		appTokenService = AppTokenService(securedStoreService: securedStoreService, persistentStoreService: persistentStoreService)
		
		let networkingService = NetworkingService(configurations: NetworkConfigurations(),
												  httpHeaderHandler: NetworkHTTPHeaderHandler(tokenService: appTokenService),
												  responseHandler: NetworkHTTPResponseHandler(),
												  networkConnectionHandler: NetworkConnectionHandler())
		
		let apiConfig = APIConfigurations()
		let queryAdapter = APIResourceQueryAdapter(config: apiConfig, tokenService: appTokenService)
		let responseAdapter = APIResourceResponseAdapter(jsonHandler: JSONDataHandler())
		
		sampleAPIService = APIService(client: networkingService, query: queryAdapter, resourceHandler: responseAdapter)
		
		// MARK: - Location
		locationManager = CLLocationManager()
		let locationConfiguration = LocationConfigurations()
		locationService = LocationService(persistentStoreService: persistentStoreService, locationManager: locationManager, configuration: locationConfiguration)
	}
}
