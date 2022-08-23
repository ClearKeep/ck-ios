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
	@State private var servers: [ServerModel] = []
	@State private var newServerDomain: String?
	
	init(container: DIContainer, isRunningTests: Bool = ProcessInfo.processInfo.isRunningTests) {
		self.container = container
		self.isRunningTests = isRunningTests
	}
	
	var body: some View {
		Group {
			if isRunningTests {
				Text("Running unit tests")
			} else {
				if !servers.isEmpty && (newServerDomain?.isEmpty ?? true) {
					HomeView()
						.inject(container)
				} else {
					LoginView(rootIsActive: .constant(false))
						.inject(container)
				}
			}
		}
		.onReceive(serversUpdate) { servers in
			if self.servers != servers {
				subscribeAndListen()
			}
			self.servers = servers
		}
		.onReceive(newServerDomainUpdate) { newServerDomain in
			self.newServerDomain = newServerDomain
		}.onOpenURL { url in
			print(url)
		}
	}
}

// MARK: - Private
private extension RootView {
	var serversUpdate: AnyPublisher<[ServerModel], Never> {
		container.appState.updates(for: \.authentication.servers)
	}
	
	var newServerDomainUpdate: AnyPublisher<String?, Never> {
		container.appState.updates(for: \.authentication.newServerDomain)
	}
}

private extension RootView {
	func subscribeAndListen() {
		container.interactors.homeInteractor.subscribeAndListenServers()
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
