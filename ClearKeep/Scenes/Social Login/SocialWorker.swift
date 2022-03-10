//
//  SocialWorker.swift
//  ClearKeep
//
//  Created by đông on 08/03/2022.
//

import UIKit
import Combine
import Common

protocol ISocialWorker {
	var remoteStore: ISocialRemoteStore { get }
	var inMemoryStore: ISocialInMemoryStore { get }

	func getSamples(samples: LoadableSubject<[ISampleModel]>)
}

struct SocialWorker {
	let remoteStore: ISocialRemoteStore
	let inMemoryStore: ISocialInMemoryStore

	init(remoteStore: ISocialRemoteStore, inMemoryStore: ISocialInMemoryStore) {
		self.remoteStore = remoteStore
		self.inMemoryStore = inMemoryStore
	}
}

extension SocialWorker: ISocialWorker {
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
