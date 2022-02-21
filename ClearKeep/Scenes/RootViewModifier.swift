//
//  RootViewModifier.swift
//  iOSBase-SwiftUI
//
//  Created by NamNH on 15/02/2022.
//

import SwiftUI
import Combine
import Common

struct RootViewAppearance: ViewModifier {
	
	@Environment(\.injected) private var injected: DIContainer
	@Environment(\.scenePhase) var scenePhase
	
	@State private var isActive: Bool = false
	internal let inspection = ViewInspector<Self>()
	
	func body(content: Content) -> some View {
		content
			.blur(radius: isActive ? 0 : 10)
			.onReceive(stateUpdate) { isActive = $0 }
			.onReceive(inspection.notice) { inspection.visit(self, $0) }
	}
	
	private var stateUpdate: AnyPublisher<Bool, Never> {
		injected.appState.updates(for: \.system.isActive)
	}
}
