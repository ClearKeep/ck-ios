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
	static let radius = 40.0
	static let spacing = 20.0
	static let padding = 10.0
	static let paddingtop = 50.0
}

struct NewPasswordContenView: View {
	// MARK: - Constants
	private let inspection = ViewInspector<Self>()

	// MARK: - Variables
	@Environment(\.colorScheme) var colorScheme
	@Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
	@Environment(\.injected) private var injected: DIContainer
	@State private(set) var password: String
	@State private(set) var rePassword: String
	@State private(set) var preAccessToken: String = ""
	@State private(set) var email: String = ""
	@State private(set) var domain: String = ""
	@State private(set) var passwordStyle: TextInputStyle
	@State private(set) var rePasswordStyle: TextInputStyle

	// MARK: - Init
	init(password: String = "",
		 rePassword: String = "",
		 passwordStyle: TextInputStyle = .default,
		 rePasswordStyle: TextInputStyle = .default) {
		self._password = .init(initialValue: password)
		self._rePassword = .init(initialValue: rePassword)
		self._passwordStyle = .init(initialValue: rePasswordStyle)
		self._rePasswordStyle = .init(initialValue: rePasswordStyle)
	}

	// MARK: - Body
	var body: some View {
		content
			.background(backgroundViewColor)
			.edgesIgnoringSafeArea(.all)
			.navigationBarBackButtonHidden(true)
	}
}

	// MARK: - Private
private extension NewPasswordContenView {

	var backgroundButton: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.offWhite : AppTheme.shared.colorSet.primaryDefault
	}

	var backgroundViewColor: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.primaryDefault : AppTheme.shared.colorSet.black
	}

	var foregroundButton: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.primaryDefault : AppTheme.shared.colorSet.offWhite
	}
	var foregroundBackButton: Color {
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

	var content: AnyView {
		AnyView(newPasswordView)
	}
}

	// MARK: - Loading Content
private extension NewPasswordContenView {
	var newPasswordView: some View {
		VStack(spacing: Constants.spacing) {
			buttonBack
				.padding(.top, Constants.paddingtop)
				.frame(maxWidth: .infinity, alignment: .leading)
			Text("ForgotPass.TitleChangePassword".localized)
				.font(AppTheme.shared.fontSet.font(style: .body2))
				.foregroundColor(foregroundBackButton)
			SecureTextField(secureText: $password,
							inputStyle: $passwordStyle,
							inputIcon: AppTheme.shared.imageSet.lockIcon,
							placeHolder: "General.Password".localized,
							keyboardType: .default )
			SecureTextField(secureText: $rePassword,
							inputStyle: $rePasswordStyle,
							inputIcon: AppTheme.shared.imageSet.lockIcon,
							placeHolder: "General.ConfirmPassword".localized,
							keyboardType: .default )
			buttonSave
			Spacer()
		}
		.frame(maxWidth: .infinity, alignment: .center)
		.padding(.all, Constants.padding)
	}

	var buttonBack: some View {
		Button(action: customBack) {
			HStack(spacing: Constants.spacing) {
				AppTheme.shared.imageSet.backIcon
					.renderingMode(.template)
					.aspectRatio(contentMode: .fit)
					.foregroundColor(foregroundBackButton)
				Text("ForgotPass.NewPassword".localized)
					.padding(.all)
					.font(AppTheme.shared.fontSet.font(style: .body2))
			}
			.foregroundColor(foregroundBackButton)
		}
	}

	var buttonSave: some View {
		Button("ForgotPass.Save".localized) {
			doResetPassword()
		}
		.frame(maxWidth: .infinity, alignment: .center)
		.padding(.all, Constants.padding)
		.background(backgroundButton)
		.foregroundColor(foregroundButton)
		.cornerRadius(Constants.radius)
	}
}
	// MARK: - Interactor

	// MARK: - Preview
#if DEBUG
struct NewPasswordContenView_Previews: PreviewProvider {
	static var previews: some View {
		NewPasswordContenView()
	}
}
#endif
