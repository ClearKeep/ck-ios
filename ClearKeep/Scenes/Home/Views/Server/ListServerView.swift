//
//  ListServerView.swift
//  ClearKeep
//
//  Created by NamNH on 12/05/2022.
//

import SwiftUI
import Combine
import CommonUI

private enum Constants {
	static let paddingVertical = 20.0
	static let cornerRadius = 32.0
	static let spacing = 20.0
	static let buttonCornerRadius = 4.0
	static let serverButtonSize = CGSize(width: 28.0, height: 28.0)
	static let contentWidth = 66.0
	static let opacity = 0.72
}

struct ListServerView: View {
	// MARK: - Variables
	@Environment(\.colorScheme) var colorScheme
	@Environment(\.injected) private var injected: DIContainer
	@Binding var servers: [ServerViewModel]
	@Binding var isAddNewServer: Bool
	@State private var selectedServer: ServerViewModel?
	let action: () -> Void
	
	// MARK: - Init
	init(servers: Binding<[ServerViewModel]>, isAddNewServer: Binding<Bool>, action: @escaping () -> Void) {
		self._servers = servers
		self._isAddNewServer = isAddNewServer
		self.action = action
	}
	
	// MARK: - Body
	var body: some View {
		VStack(alignment: .center, spacing: Constants.spacing) {
			ForEach(servers) { server in
				ServerButton(server, isSelected: server.isActive && !isAddNewServer) { didSelectServer(server) }
					.frame(width: Constants.serverButtonSize.width, height: Constants.serverButtonSize.height)
					.cornerRadius(Constants.buttonCornerRadius)
			}
			ServerButton(AppTheme.shared.imageSet.plusIcon, isSelected: isAddNewServer, action: addServerAction)
				.frame(width: Constants.serverButtonSize.width, height: Constants.serverButtonSize.height)
				.cornerRadius(Constants.buttonCornerRadius)
			Spacer()
		}
		.padding(.vertical, Constants.paddingVertical)
		.frame(width: Constants.contentWidth)
		.frame(maxHeight: .infinity)
		.background(
			ZStack {
				RoundedCorner(radius: Constants.cornerRadius, rectCorner: .topRight)
					.fill(
						LinearGradient(gradient: Gradient(colors: colorScheme == .light ? AppTheme.shared.colorSet.gradientLinear : [AppTheme.shared.colorSet.darkgrey3]),
									   startPoint: .leading,
									   endPoint: .trailing)
					)
				RoundedCorner(radius: Constants.cornerRadius, rectCorner: .topRight)
					.foregroundColor(colorScheme == .light ? AppTheme.shared.colorSet.offWhite.opacity(Constants.opacity) : AppTheme.shared.colorSet.darkgrey3.opacity(Constants.opacity))
			}
		)
		.edgesIgnoringSafeArea(.bottom)
	}
}

// MARK: - Private
private extension ListServerView {
}

// MARK: - Action
private extension ListServerView {
	func didSelectServer(_ server: ServerViewModel) {
		isAddNewServer = false
		servers = injected.interactors.homeInteractor.didSelectServer(server.serverDomain)
		action()
	}
	
	func addServerAction() {
		isAddNewServer = true
		servers = injected.interactors.homeInteractor.didSelectServer(nil)
	}
}
