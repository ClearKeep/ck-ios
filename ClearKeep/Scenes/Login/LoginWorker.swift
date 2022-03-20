//
//  LoginWorker.swift
//  ClearKeep
//
//  Created by đông on 07/03/2022.
//

import UIKit
import Combine
import Common

protocol ILoginWorker {
	var remoteStore: ILoginRemoteStore { get }
	var inMemoryStore: ILoginInMemoryStore { get }

	func getSamples(samples: LoadableSubject<[ISampleModel]>)
}

struct LoginWorker {
	let remoteStore: ILoginRemoteStore
	let inMemoryStore: ILoginInMemoryStore

	init(remoteStore: ILoginRemoteStore, inMemoryStore: ILoginInMemoryStore) {
		self.remoteStore = remoteStore
		self.inMemoryStore = inMemoryStore
	}
}

extension LoginWorker: ILoginWorker {
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
