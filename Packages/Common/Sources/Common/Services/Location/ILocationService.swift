//
//  LocationService.swift
//  Common
//
//  Created by NamNH on 30/09/2021.
//

import CoreLocation

public protocol ILocationConfig {
	var defaultLatitude: Double { get }
	var defaultLongitude: Double { get }
}

public protocol ILocationService {
	var lastKnownLocation: CLLocation? { get }
	var isLocationServiceEnabled: Bool { get }
	var authorizationStatus: CLAuthorizationStatus { get }
	var defaultLatitude: Double { get }
	var defaultLongitude: Double { get }
	
	func requestForPermission(completion: @escaping (Result<Bool, Error>) -> Void)
	func requestForPermissionWithAuthorizationStatus(completion: @escaping (Result<CLAuthorizationStatus, Error>) -> Void)
	func requestLocation()
	func reverseGeocodeLocation(_ latitude: Double, longitude: Double, completionHandler: @escaping (Result<String?, Error>) -> Void)
}

public enum LocationServiceError: Error {
	case locationServicesDisable
	case unknownUserLocation
	
	public var message: String {
		switch self {
		case .locationServicesDisable:
			return "Location services are not enabled"
		case .unknownUserLocation:
			return "Unknown user location"
		}
	}
	
}

extension Notification.Name {
	public enum LocationService {
		public static let didChangeAuthorizationStatus = Notification.Name("LocationService.didChangeAuthorizationStatus")
		public static let didChangeLocation = Notification.Name("LocationService.didChangeLocation")
	}
}
