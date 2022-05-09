//
//  FogotPasswordContentView.swift
//  ClearKeep
//
//  Created by MinhDev on 22/03/2022.
//

import SwiftUI
import CommonUI
import Common

private enum Constants {
	static let spacing = 40.0
	static let padding = 30.0
	static let paddingTextfield = 24.0
	static let paddingText = 10.0
	static let paddingLeading = 16.0
	static let submitButtonHeight = 40.0
}

struct FogotPasswordContentView: View {
	// MARK: - Constants
	private let inspection = ViewInspector<Self>()

	// MARK: - Variables
	@Environment(\.colorScheme) var colorScheme
	@Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
	@Environment(\.injected) private var injected: DIContainer
	@State private(set) var email: String = ""
	@State private(set) var domain: String = ""
	@State private(set) var emailStyle: TextInputStyle = .default
	@State private(set) var showingNewPass: Bool = false

	// MARK: - Body
	var body: some View {
		VStack(spacing: Constants.spacing) {
			Text("ForgotPassword.Description".localized)
				.font(AppTheme.shared.fontSet.font(style: .input2))
				.foregroundColor(titleColor)
				.frame(maxWidth: .infinity, alignment: .leading)
			VStack(spacing: Constants.paddingTextfield) {
				CommonTextField(text: $email,
								inputStyle: $emailStyle,
								inputIcon: AppTheme.shared.imageSet.mailIcon,
								placeHolder: "General.Email".localized,
								keyboardType: .default,
								onEditingChanged: { isEditing in
					emailStyle = isEditing ? .default : .normal
				})
				NavigationLink(
					destination: NewPasswordView(),
					isActive: $showingNewPass,
					label: {
						RoundedButton("ForgotPassword.ResetPassword".localized,
									  disable: .constant(email.isEmpty)) {
							showingNewPass = true
						}.frame(height: Constants.submitButtonHeight)
					})
			}
			Spacer()
		}
		.frame(maxWidth: .infinity, alignment: .center)
		.padding(.horizontal, Constants.paddingLeading)
		.edgesIgnoringSafeArea(.all)
	}
}

// MARK: - Private
private extension FogotPasswordContentView {
	var titleColor: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.offWhite : AppTheme.shared.colorSet.grey3
	}

}

// MARK: - Private Func
private extension FogotPasswordContentView {

	func doFogotPassword() {
		Task {
			await injected.interactors.fogotPasswordInteractor.recoverPassword(email: email, domain: domain)
		}
	}

}
// MARK: - Preview
#if DEBUG
struct FogotPasswordContentView_Previews: PreviewProvider {
	static var previews: some View {
		FogotPasswordContentView(emailStyle: .default)
	}
}
#endif
