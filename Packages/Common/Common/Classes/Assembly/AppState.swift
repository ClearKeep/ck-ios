//
//  AppState.swift
//  Common
//
//  Created by NamNH on 15/02/2022.
//

import SwiftUI
import Combine

public struct AppState: Equatable {
	public var userData = UserData()
	public var system = System()
	
	public init() {}
}

public extension AppState {
	struct UserData: Equatable {
	}
}

public extension AppState {
	struct System: Equatable {
		public var isActive: Bool = false
		public var keyboardHeight: CGFloat = 0
	}
}

public func == (lhs: AppState, rhs: AppState) -> Bool {
	return lhs.userData == rhs.userData &&
		lhs.system == rhs.system
}

public extension AppState {
	static var preview: AppState {
		var state = AppState()
		state.system.isActive = true
		return state
	}
}
