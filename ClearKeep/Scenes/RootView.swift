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
import ChatSecure

struct RootView: View {
	private let container: DIContainer
	private let isRunningTests: Bool
	@State private var isLoggedIn: Bool = false
	@State private var servers: [ServerModel] = []
	@State private var newServerDomain: String?
	@State private var isFirstLoad: Bool = true
	
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
			if servers.count > self.servers.count && !isFirstLoad {
				subscribeAndListen()
			}
			isFirstLoad = false
			self.servers = servers
		}
		.onReceive(newServerDomainUpdate) { newServerDomain in
			self.newServerDomain = newServerDomain
		}.onReceive(NotificationCenter.default.publisher(for: Notification.Name.ForgotPasswordService.forgotSuccess)) { data in
			guard let servers = data.object as? [RealmServer] else {
				return
			}
			
			DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
				container.appState.bulkUpdate {
					$0.authentication.servers = servers.compactMap { ServerModel($0) }
					$0.authentication.newServerDomain = nil
				}
				
				self.servers = servers.compactMap { ServerModel($0) }
				self.newServerDomain = nil
			})
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
