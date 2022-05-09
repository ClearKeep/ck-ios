//
//  AdvancerContentView.swift
//  ClearKeep
//
//  Created by MinhDev on 22/03/2022.
//

import SwiftUI
import CommonUI
import Common

private enum Constants {
	static let spacing = 20.0
	static let padding = 16.0
	static let paddingTopButton = 38.0
	static let submitButtonHeight = 40.0
}

struct AdvancedContentView: View {
	// MARK: - Constants
	private let inspection = ViewInspector<Self>()

	// MARK: - Variables
	@Environment(\.colorScheme) var colorScheme
	@Environment(\.injected) private var injected: DIContainer
	@State private(set) var severUrl: String = ""
	@State private(set) var severUrlStyle: TextInputStyle = .default
	@State private(set) var isShowingView: Bool = false
	@State private(set) var isLogin: Bool = false

	// MARK: - Init

	// MARK: - Body
	var body: some View {
		VStack(spacing: Constants.spacing) {
			CheckBoxButtons(text: "AdvancedServer.SeverButton".localized, isChecked: $isShowingView)
				.foregroundColor(foregroundCheckmask)
				.frame(maxWidth: .infinity, alignment: .leading)
			if isShowingView {
				Text("AdvancedServer.Title".localized)
					.font(AppTheme.shared.fontSet.font(style: .body2))
					.foregroundColor(foregroundBackButton)
					.frame(maxWidth: .infinity, alignment: .leading)
				CommonTextField(text: $severUrl,
								inputStyle: $severUrlStyle,
								inputIcon: AppTheme.shared.imageSet.mailIcon,
								placeHolder: "AdvancedServer.ServerUrl".localized,
								keyboardType: .default,
								onEditingChanged: { isEditing in
					severUrlStyle = isEditing ? .highlighted : .normal
				})
				NavigationLink(
					destination: LoginView(isCustomServer: true),
					isActive: $isLogin,
					label: {
						RoundedButton("AdvancedServer.Submit".localized, disable: .constant(severUrl.isEmpty)) {
								isLogin.toggle()
						}
						.frame(height: Constants.submitButtonHeight)
						.frame(maxWidth: .infinity)
					})
					.padding(.top, Constants.paddingTopButton)
				Spacer()
			}
			Spacer()
		}
		.padding(.horizontal, Constants.padding)
		.background(backgroundColorView)
		.edgesIgnoringSafeArea(.all)
	}
}

// MARK: - Private
private extension AdvancedContentView {
	var backgroundColorView: LinearGradient {
		colorScheme == .light ? backgroundColorGradient : backgroundColorBlack
	}

	var backgroundColorBlack: LinearGradient {
		LinearGradient(gradient: Gradient(colors: AppTheme.shared.colorSet.gradientBlack), startPoint: .leading, endPoint: .trailing)
	}

	var backgroundColorGradient: LinearGradient {
		LinearGradient(gradient: Gradient(colors: AppTheme.shared.colorSet.gradientPrimary), startPoint: .leading, endPoint: .trailing)
	}

	var foregroundBackButton: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.offWhite : AppTheme.shared.colorSet.grey3
	}

	var foregroundCheckmask: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.offWhite : AppTheme.shared.colorSet.grey3
	}
}

// MARK: - Private Func
private extension AdvancedContentView {
	func showAction() {
		isShowingView.toggle()
	}
}

// MARK: - Interactor

// MARK: - Preview
#if DEBUG
struct AdvancedContentView_Previews: PreviewProvider {
	static var previews: some View {
		AdvancedContentView(severUrl: "", severUrlStyle: (.default))
	}
}
#endif
