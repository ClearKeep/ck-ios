//
//  NewPasswordView.swift
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

struct NewPasswordView: View {
	// MARK: - Constants
	private let inspection = ViewInspector<Self>()

	// MARK: - Variables
	@Environment(\.injected) private var injected: DIContainer
	@Environment(\.colorScheme) var colorScheme
	@Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

	let preAccessToken: String
	let email: String
	let domain: String
	
	// MARK: - Init
	init(preAccessToken: String, email: String, domain: String) {
		self.preAccessToken = preAccessToken
		self.email = email
		self.domain = domain
	}
	
	// MARK: - Body
	var body: some View {
		content
			.onReceive(inspection.notice) { inspection.visit(self, $0) }
			.applyNavigationBarPlainStyle(title: "NewPassword.Title".localized,
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
private extension NewPasswordView {
	var content: AnyView {
		AnyView(notRequestedView)
	}
}

// MARK: - Loading Content
private extension NewPasswordView {
	var notRequestedView: some View {
		NewPasswordContenView(preAccessToken: self.preAccessToken, email: self.email, domain: self.domain)
	}
}

// MARK: - Private variable
private extension NewPasswordView {
	var titleColor: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.offWhite : AppTheme.shared.colorSet.grey3
	}
}

// MARK: - Private func
private extension NewPasswordView {
	func customBack() {
		self.presentationMode.wrappedValue.dismiss()
	}
}

// MARK: - Preview
#if DEBUG
struct NewPasswordView_Previews: PreviewProvider {
	static var previews: some View {
		NewPasswordView(preAccessToken: "", email: "", domain: "")
	}
}
#endif
