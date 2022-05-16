//
//  ListServerView.swift
//  ClearKeep
//
//  Created by NamNH on 12/05/2022.
//

import SwiftUI
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
	@Binding var servers: [ServerViewModel]
	@Binding var selectedServer: ServerViewModel?
	@State private var isAddServerSelected: Bool = false
	
	// MARK: - Init
	
	// MARK: - Body
	var body: some View {
		VStack(alignment: .center, spacing: Constants.spacing) {
			ForEach(servers) { server in
				ServerButton(server, isSelected: server.id == selectedServer?.id) { didSelectServer(server) }
					.frame(width: Constants.serverButtonSize.width, height: Constants.serverButtonSize.height)
					.cornerRadius(Constants.buttonCornerRadius)
			}
			ServerButton(AppTheme.shared.imageSet.plusIcon, isSelected: isAddServerSelected, action: addServerAction)
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

// MARK: - Action
private extension ListServerView {
	func didSelectServer(_ server: ServerViewModel) {
		selectedServer = server
		isAddServerSelected = false
	}
	
	func addServerAction() {
		selectedServer = nil
		isAddServerSelected = true
	}
}
