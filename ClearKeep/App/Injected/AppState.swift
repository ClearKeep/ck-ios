//
//  AppState.swift
//  ClearKeep
//
//  Created by NamNH on 28/04/2022.
//

import SwiftUI
import Combine
import Model

public struct AppState: Equatable {
	public var authentication: IAuthenticationModel?
	public var system = System()
	
	public init() {}
}
public extension AppState {
	struct System: Equatable {
		public var isActive: Bool = false
		public var keyboardHeight: CGFloat = 0
	}
}

public func == (lhs: AppState, rhs: AppState) -> Bool {
	return lhs.system == rhs.system
}

public extension AppState {
	static var preview: AppState {
		var state = AppState()
		state.system.isActive = true
		return state
	}
}
