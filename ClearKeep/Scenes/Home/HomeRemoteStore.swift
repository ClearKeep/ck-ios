//
//  HomeRemoteStore.swift
//  iOSBase-SwiftUI
//
//  Created by NamNH on 15/02/2022.
//

import Foundation
import Combine

protocol IHomeRemoteStore {
	func getSamples(completion: @escaping (Result<[ISampleModel], Error>) -> Void)
}

struct HomeRemoteStore {
	let sampleAPIService: IAPIService
}

extension HomeRemoteStore: IHomeRemoteStore {
	func getSamples(completion: @escaping (Result<[ISampleModel], Error>) -> Void) {
		sampleAPIService.getSamples(completion: completion)
	}
}
