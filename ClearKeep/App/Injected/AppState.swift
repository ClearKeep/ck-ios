//
//  AppState.swift
//  ClearKeep
//
//  Created by NamNH on 28/04/2022.
//

import SwiftUI
import Combine
import Model

struct AppState: Equatable {
	public var authentication = Authentication()
	public var system = System()
	
	public init() {}
}

extension AppState {
	struct System: Equatable {
		var isActive: Bool = false
		var keyboardHeight: CGFloat = 0
	}
	
	struct Authentication: Equatable {
		static func == (lhs: AppState.Authentication, rhs: AppState.Authentication) -> Bool {
			return lhs.servers == rhs.servers
		}
		
		var servers: [ServerModel] = []
		var accessTokens: [String: String] = [:]
		var newServerDomain: String?
	}
}

func == (lhs: AppState, rhs: AppState) -> Bool {
	return lhs.system == rhs.system && lhs.authentication == rhs.authentication
}

extension AppState {
	static var preview: AppState {
		var state = AppState()
		state.system.isActive = true
		return state
	}
}
