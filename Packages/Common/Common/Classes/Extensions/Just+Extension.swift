//
//  Just+Extension.swift
//  Common
//
//  Created by NamNH on 16/02/2022.
//

import Combine

public extension Just where Output == Void {
	static func withErrorType<E>(_ errorType: E.Type) -> AnyPublisher<Void, E> {
		return withErrorType((), E.self)
	}
}

public extension Just {
	static func withErrorType<E>(_ value: Output, _ errorType: E.Type
	) -> AnyPublisher<Output, E> {
		return Just(value)
			.setFailureType(to: E.self)
			.eraseToAnyPublisher()
	}
}
