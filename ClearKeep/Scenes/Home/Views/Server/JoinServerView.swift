//
//  JoinServerView.swift
//  ClearKeep
//
//  Created by NamNH on 12/05/2022.
//

import SwiftUI
import CommonUI

private enum Constants {
	static let padding = 20.0
	static let spacing = 12.0
}

struct JoinServerView: View {
	// MARK: - Variables
	@Environment(\.colorScheme) var colorScheme
	@Environment(\.injected) private var injected: DIContainer
	@State private(set) var serverURL: String = ""
	@State private var serverURLInputStyle: TextInputStyle = .default
	var checkUrl: (String) -> Void

	// MARK: - Body
	var body: some View {
		VStack {
			Text("JoinServer.Description".localized)
				.padding(.bottom, Constants.padding)
				.frame(maxWidth: .infinity, alignment: .leading)
				.font(AppTheme.shared.fontSet.font(style: .input3))
				.foregroundColor(colorScheme == .light ? AppTheme.shared.colorSet.grey1 : AppTheme.shared.colorSet.greyLight)
			VStack(spacing: Constants.spacing) {
				CommonTextField(text: $serverURL,
								inputStyle: $serverURLInputStyle,
								placeHolder: "JoinServer.ServerURL.Placeholder".localized,
								keyboardType: .default,
								onEditingChanged: { isEditting in
					serverURLInputStyle = isEditting ? .highlighted : .normal
				})
				RoundedGradientButton("JoinServer.Join".localized, disabled: .constant(serverURL.isEmpty), action: joinServerAction)
				Text("JoinServer.Tips".localized)
					.frame(maxWidth: .infinity, alignment: .leading)
					.font(AppTheme.shared.fontSet.font(style: .placeholder3))
					.foregroundColor(colorScheme == .light ? AppTheme.shared.colorSet.grey3 : AppTheme.shared.colorSet.primaryDefault)
			}
			Spacer()
		}
	}
}

// MARK: - Action
private extension JoinServerView {
	func joinServerAction() {
		checkUrl(serverURL)
	}
}
