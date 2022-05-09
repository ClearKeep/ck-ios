//
//  FogotPasswordView.swift
//  ClearKeep
//
//  Created by MinhDev on 22/03/2022.
//

import SwiftUI
import Common
import CommonUI

private enum Constants {
	static let imageScale = 40.0
}

struct FogotPasswordView: View {
	// MARK: - Constants
	private let inspection = ViewInspector<Self>()

	// MARK: - Variables
	@Environment(\.injected) private var injected: DIContainer
	@Environment(\.colorScheme) var colorScheme
	@Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
	@Binding var customServer: CustomServer
	
	// MARK: - Body
	var body: some View {
		content
			.onReceive(inspection.notice) { inspection.visit(self, $0) }
			.applyNavigationBarPlainStyle(title: "ForgotPassword.Title".localized,
										  titleColor: titleColor,
										  leftBarItems: {
				BackButton(customBack)
			},
										  rightBarItems: {
				Spacer()
			})
			.hideKeyboardOnTapped()
			.grandientBackground()
	}
}

// MARK: - Private
private extension FogotPasswordView {
	var content: AnyView {
		AnyView(notRequestedView)
	}
}

// MARK: - Loading Content
private extension FogotPasswordView {
	var notRequestedView: some View {
		FogotPasswordContentView(customServer: $customServer)
	}
}

// MARK: - Private variable
private extension FogotPasswordView {
	var titleColor: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.offWhite : AppTheme.shared.colorSet.grey3
	}
}

// MARK: - Private func
private extension FogotPasswordView {
	func customBack() {
		self.presentationMode.wrappedValue.dismiss()
	}
}

// MARK: - Preview
#if DEBUG
struct FogotPasswordView_Previews: PreviewProvider {
	static var previews: some View {
		FogotPasswordView(customServer: .constant(CustomServer()))
	}
}
#endif
