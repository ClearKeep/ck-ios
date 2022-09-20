//
//  JoinServerEnviromentKey.swift
//  ClearKeep
//
//  Created by HOANDHTB on 18/08/2022.
//

import SwiftUI

typealias JoinServerClosure = ((String) -> Void)?

class JoinServerEnviromentKey: EnvironmentKey {
	static let defaultValue : JoinServerClosure = { _ in }
}

extension EnvironmentValues {
	var joinServerClosure: JoinServerClosure {
		get { self[JoinServerEnviromentKey.self] }
		set { self[JoinServerEnviromentKey.self] = newValue }
	}
}
