//
//  LocationService.swift
//  iOSBase
//
//  Created by NamNH on 17/11/2021.
//

// swiftlint:disable multiline_literal_brackets
import CoreLocation
import Common

class LocationService: NSObject {
	typealias AwaitForAuthorizationResultHandler = (Result<CLAuthorizationStatus, Error>) -> Void
	private var awaitAuthorizationCompletion: AwaitForAuthorizationResultHandler?
	
	private var persistentStoreService: IPersistentStoreService!
	private var locationManager: CLLocationManager!
	private var configuration: ILocationConfig!
	
	init(persistentStoreService: IPersistentStoreService, locationManager: CLLocationManager, configuration: ILocationConfig) {
		super.init()
		self.persistentStoreService = persistentStoreService
		self.locationManager = locationManager
		self.configuration = configuration
		setupLocationManager()
	}
	
	deinit {
		destroyLocationManager()
	}
}

// MARK: - Private

private extension LocationService {
	
	func setupLocationManager() {
		locationManager?.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
		locationManager?.delegate = self
	}
	
	func destroyLocationManager() {
		locationManager?.stopUpdatingLocation()
		locationManager?.delegate = nil
		locationManager = nil
	}
	
	func handle(location: CLLocation) {
		locationManager?.stopUpdatingLocation()
		
		let locationData = try? NSKeyedArchiver.archivedData(withRootObject: location, requiringSecureCoding: false)
		persistentStoreService.set(value: locationData, key: "Location.address.titleKey")
		
		NotificationCenter.default.post(name: NSNotification.Name.LocationService.didChangeLocation, object: nil)
	}
	
	func getLocation() -> CLLocation? {
		guard let locationData = UserDefaults.standard.data(forKey: "Location.address.titleKey") else { return nil }
		return try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(locationData) as? CLLocation
	}
	
	func handle(authorizationStatus: CLAuthorizationStatus?) {
		switch authorizationStatus {
		case .authorizedAlways, .authorizedWhenInUse:
			locationManager?.startUpdatingLocation()
		default: break
		}
		NotificationCenter.default.post(name: NSNotification.Name.LocationService.didChangeAuthorizationStatus, object: nil)
		
		if let status = authorizationStatus {
			awaitAuthorizationCompletion?(.success(status))
			awaitAuthorizationCompletion = nil
		}
	}
	
	func handle(error: Error) {
		NotificationCenter.default.post(name: NSNotification.Name.LocationService.didChangeAuthorizationStatus, object: nil)
	}
}

// MARK: - ILocationService

extension LocationService: ILocationService {
	
	var authorizationStatus: CLAuthorizationStatus {
		if #available(iOS 14.0, *) {
			return locationManager?.authorizationStatus ?? CLAuthorizationStatus.restricted
		} else {
			return CLLocationManager.authorizationStatus()
		}
	}
	
	var lastKnownLocation: CLLocation? {
		getLocation()
	}
	
	var isLocationServiceEnabled: Bool {
		CLLocationManager.locationServicesEnabled()
	}
	
	func requestForPermission(completion: @escaping (Result<Bool, Error>) -> Void) {
		guard isLocationServiceEnabled else {
			completion(.failure(LocationServiceError.locationServicesDisable))
			return
		}
		DispatchQueue.main.async { [weak self] in
			self?.locationManager?.requestWhenInUseAuthorization()
			completion(.success(true))
		}
	}
	
	func requestForPermissionWithAuthorizationStatus(completion: @escaping (Result<CLAuthorizationStatus, Error>) -> Void) {
		guard isLocationServiceEnabled else {
			completion(.failure(LocationServiceError.locationServicesDisable))
			return
		}
		
		switch authorizationStatus {
		case .authorizedAlways, .authorizedWhenInUse, .denied:
			completion(.success(authorizationStatus))
		case .notDetermined, .restricted:
			
			awaitAuthorizationCompletion = completion
			DispatchQueue.main.async { [weak self] in
				self?.locationManager?.requestWhenInUseAuthorization()
			}
			
		@unknown default:
			completion(.success(authorizationStatus))
		}
	}

	func requestLocation() {
		locationManager?.requestLocation()
	}
	
	func reverseGeocodeLocation(_ latitude: Double, longitude: Double, completionHandler: @escaping (Result<String?, Error>) -> Void) {
		CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: latitude, longitude: longitude)) { places, error in
			if let error = error {
				completionHandler(.failure(error))
			} else {
				if let lastPlace = places?.last {
					var places: [String?] = [lastPlace.thoroughfare,
											 lastPlace.subThoroughfare,
											 lastPlace.subLocality,
											 lastPlace.locality,
											 lastPlace.country,
											 lastPlace.postalCode]
					
					if !places.contains(lastPlace.name) {
						places.insert(lastPlace.name, at: 0)
					}
					let address = places.compactMap { $0 }.joined(separator: ", ")
					completionHandler(.success(address))
					
				} else {
					completionHandler(.success(nil))
				}
			}
		}
	}
	
	var defaultLatitude: Double {
		return configuration.defaultLatitude
	}
	
	var defaultLongitude: Double {
		return configuration.defaultLongitude
	}
}

// MARK: - CLLocationManagerDelegate

extension LocationService: CLLocationManagerDelegate {
	func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
		handle(authorizationStatus: authorizationStatus)
	}
	
	func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
		handle(authorizationStatus: authorizationStatus)
	}
	
	func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
		handle(error: error)
	}
	
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		guard let lastLocation = locations.last else {
			return
		}
		handle(location: lastLocation)
	}
}
