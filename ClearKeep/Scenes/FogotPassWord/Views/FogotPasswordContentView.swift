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
	static let paddingHorizontal = 16.0
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
	@State private var emailInvalid: Bool = false
	var forgotPassword: (String) -> Void
	@State private var isShowError: Bool = false
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
					emailStyle = isEditing ? .highlighted : .normal
				})
					.onChange(of: email, perform: { text in
						invalid(text: text)
					})
				RoundedButton("ForgotPassword.ResetPassword".localized,
							  disabled: .constant(!emailInvalid),
							  action: doRecoverPassword)
			}
			Spacer()
		}
		.frame(maxWidth: .infinity, alignment: .center)
		.padding(.horizontal, Constants.paddingHorizontal)
		.edgesIgnoringSafeArea(.all)
		.alert(isPresented: $isShowError) {
			Alert(title: Text("Login.Popup.Email.Password.Validate".localized),
					 message: Text("Login.Popup.Message".localized),
					 dismissButton: .default(Text("ForgotPassword.Cancel".localized)))
		   }
	}
}

// MARK: - Private
private extension FogotPasswordContentView {
	var titleColor: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.offWhite : AppTheme.shared.colorSet.grey3
	}
}

// MARK: - Interactor
private extension FogotPasswordContentView {
	func doRecoverPassword() {
		if emailInvalid {
			self.forgotPassword(email)
		}
	}

	func invalid(text: String) {
		emailInvalid = injected.interactors.fogotPasswordInteractor.emailValid(email: email)
		emailInvalid ? { self.isShowError = true }() : doRecoverPassword()
	}
}
// MARK: - Preview
#if DEBUG
struct FogotPasswordContentView_Previews: PreviewProvider {
	static var previews: some View {
		FogotPasswordContentView(forgotPassword: { _ in })
	}
}
#endif
