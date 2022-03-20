//
//  LoginRemoteStore.swift
//  ClearKeep
//
//  Created by đông on 07/03/2022.
//

import Foundation
import Combine

protocol ILoginRemoteStore {
	func getSamples(completion: @escaping (Result<[ISampleModel], Error>) -> Void)
}

struct LoginRemoteStore {
	let sampleAPIService: IAPIService
}

extension LoginRemoteStore: ILoginRemoteStore {
	func getSamples(completion: @escaping (Result<[ISampleModel], Error>) -> Void) {
		sampleAPIService.getSamples(completion: completion)
	}
}
