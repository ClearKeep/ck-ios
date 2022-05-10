//
//  RootView.swift
//  iOSBase-SwiftUI
//
//  Created by NamNH on 15/02/2022.
//

import SwiftUI
import Combine
import Common
import Model

struct RootView: View {
	private let container: DIContainer
	private let isRunningTests: Bool
	@State private var isLoggedIn: Bool = false
	
	init(container: DIContainer, isRunningTests: Bool = ProcessInfo.processInfo.isRunningTests) {
		self.container = container
		self.isRunningTests = isRunningTests
	}
	
	var body: some View {
		Group {
			if isRunningTests {
				Text("Running unit tests")
			} else {
				if isLoggedIn {
					HomeHeaderView(inputStyle: .constant(.default))
						.inject(container)
				} else {
					LoginView()
						.inject(container)
				}
			}
		}.onReceive(stateUpdate) { accessToken in
			isLoggedIn = accessToken != nil
		}
	}
}

// MARK: - Private
private extension RootView {
	var stateUpdate: AnyPublisher<String?, Never> {
		container.appState.updates(for: \.authentication.accessToken)
	}
}

// MARK: - Preview
#if DEBUG
struct RootView_Previews: PreviewProvider {
	static var previews: some View {
		RootView(container: .preview)
	}
}
#endif
