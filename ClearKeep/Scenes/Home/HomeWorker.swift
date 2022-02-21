//
//  HomeWorker.swift
//  iOSBase-SwiftUI
//
//  Created by NamNH on 15/02/2022.
//

import UIKit
import Combine
import Common

protocol IHomeWorker {
	var remoteStore: IHomeRemoteStore { get }
	var inMemoryStore: IHomeInMemoryStore { get }
	
	func getSamples(samples: LoadableSubject<[ISampleModel]>)
}

struct HomeWorker {
	let remoteStore: IHomeRemoteStore
	let inMemoryStore: IHomeInMemoryStore
	
	init(remoteStore: IHomeRemoteStore, inMemoryStore: IHomeInMemoryStore) {
		self.remoteStore = remoteStore
		self.inMemoryStore = inMemoryStore
	}
}

extension HomeWorker: IHomeWorker {
	func getSamples(samples: LoadableSubject<[ISampleModel]>) {
		let cancelBag = CancelBag()
		samples.wrappedValue.setIsLoading(cancelBag: cancelBag)
		
		Just<Void>
			.withErrorType(Error.self)
			.flatMap {
				return Deferred {
					Future<[ISampleModel], Error> { promise in
						self.remoteStore.getSamples(completion: { result in
							switch result {
							case .success(let sampleDatas):
								promise(.success(sampleDatas))
							case .failure(let error):
								promise(.failure(error))
							}
						})
					}
				}
				.eraseToAnyPublisher()
			}
			.sinkToLoadable { samples.wrappedValue = $0 }
			.store(in: cancelBag)
	}
}
