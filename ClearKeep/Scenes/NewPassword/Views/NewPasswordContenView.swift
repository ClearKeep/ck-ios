//
//  NewPasswordContenView.swift
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
	static let paddingLeading = 16.0
}

struct NewPasswordContenView: View {
	// MARK: - Constants
	private let inspection = ViewInspector<Self>()

	// MARK: - Variables
	@Environment(\.colorScheme) var colorScheme
	@Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
	@Environment(\.injected) private var injected: DIContainer
	@State private(set) var password: String = ""
	@State private(set) var rePassword: String = ""
	@State private(set) var passwordStyle: TextInputStyle = .default
	@State private(set) var rePasswordStyle: TextInputStyle = .default
	@State private(set) var isLogin: Bool = false
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
		VStack(spacing: Constants.spacing) {
			Text("NewPassword.Description".localized)
				.font(AppTheme.shared.fontSet.font(style: .input2))
				.foregroundColor(titleColor)
				.frame(maxWidth: .infinity, alignment: .leading)
			VStack(spacing: Constants.paddingTextfield) {
				SecureTextField(secureText: $password,
								inputStyle: $passwordStyle,
								inputIcon: AppTheme.shared.imageSet.lockIcon,
								placeHolder: "NewPassword.NewPassword".localized,
								keyboardType: .default,
								onEditingChanged: { isEdit in
					passwordStyle = isEdit ? .highlighted : .normal
				})
				SecureTextField(secureText: $rePassword,
								inputStyle: $rePasswordStyle,
								inputIcon: AppTheme.shared.imageSet.lockIcon,
								placeHolder: "General.ConfirmPassword".localized,
								keyboardType: .default,
								onEditingChanged: { isEdit in
					rePasswordStyle = isEdit ? .highlighted : .normal
				})
				NavigationLink(
					destination: LoginView(),
					isActive: $isLogin,
					label: {
						RoundedButton("General.Save".localized,
									  disabled: .constant(password.isEmpty || rePassword.isEmpty)) {
							isLogin = true
						}
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
private extension NewPasswordContenView {
	var titleColor: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.offWhite : AppTheme.shared.colorSet.grey3
	}
}

// MARK: - Private Func
private extension NewPasswordContenView {
	func customBack() {
		self.presentationMode.wrappedValue.dismiss()
	}

	func doResetPassword() {
		Task {
			await injected.interactors.newPasswordInteractor.resetPassword(preAccessToken: preAccessToken, email: email, rawNewPassword: password, domain: domain)
		}
	}
}

// MARK: - Preview
#if DEBUG
struct NewPasswordContenView_Previews: PreviewProvider {
	static var previews: some View {
		NewPasswordContenView(preAccessToken: "", email: "", domain: "")
	}
}
#endif
