//
//  SocialRemoteStore.swift
//  ClearKeep
//
//  Created by đông on 08/03/2022.
//

import Foundation
import Combine

protocol ISocialRemoteStore {
	func getSamples(completion: @escaping (Result<[ISampleModel], Error>) -> Void)
}

struct SocialRemoteStore {
	let sampleAPIService: IAPIService
}

extension SocialRemoteStore: ISocialRemoteStore {
	func getSamples(completion: @escaping (Result<[ISampleModel], Error>) -> Void) {
		sampleAPIService.getSamples(completion: completion)
	}
}
