//
//  ChangePasswordContentView.swift
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

struct ChangePasswordContentView: View {
	// MARK: - Constants
	private let inspection = ViewInspector<Self>()
	
	// MARK: - Variables
	@Environment(\.colorScheme) var colorScheme
	@Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
	@Environment(\.injected) private var injected: DIContainer
	@State private(set) var preAccessToken: String = ""
	@State private(set) var email: String = ""
	@State private(set) var domain: String = ""
	@State private(set) var currentPassword: String = ""
	@State private(set) var newPassword: String = ""
	@State private(set) var confirmPassword: String = ""
	@State private(set) var currentStyle: TextInputStyle = .default
	@State private(set) var newStyle: TextInputStyle = .default
	@State private(set) var confirmStyle: TextInputStyle = .default
	@State private var passwordInvalid: Bool = false
	@State private var confirmPasswordInvvalid: Bool = false
	@State private var checkInvalid: Bool = false

	// MARK: - Init

	// MARK: - Body
	var body: some View {
		content
			.background(backgroundViewColor)
			.edgesIgnoringSafeArea(.all)
	}
}

// MARK: - Private
private extension ChangePasswordContentView {
	
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
private extension ChangePasswordContentView {
	func customBack() {
		self.presentationMode.wrappedValue.dismiss()
	}
	
	var content: AnyView {
		AnyView(changePasswordView)
	}

	func dochangPassword() {
		invalid()
		if checkInvalid {
			Task {
				await injected.interactors.changePasswordInteractor.resetPassword(preAccessToken: preAccessToken, email: email, rawNewPassword: newPassword, domain: domain)
			}
		}
	}

	func invalid() {

		passwordInvalid = injected.interactors.changePasswordInteractor.passwordValid(password: newPassword)
		newStyle = passwordInvalid ? .normal : .error(message: "General.Password.Valid".localized)

		confirmPasswordInvvalid = injected.interactors.changePasswordInteractor.confirmPasswordValid(password: newPassword, confirmPassword: confirmPassword)
		confirmStyle = confirmPasswordInvvalid ? .normal : .error(message: "General.ConfirmPassword.Valid".localized)

		checkInvalid = injected.interactors.changePasswordInteractor.checkValid(passwordValdid: passwordInvalid, confirmPasswordValid: confirmPasswordInvvalid)
	}
}

// MARK: - Loading Content
private extension ChangePasswordContentView {
	var changePasswordView: some View {
		VStack(spacing: Constants.spacing) {
			buttonBack
				.padding(.top, Constants.paddingtop)
				.frame(maxWidth: .infinity, alignment: .leading)
			Text("ChangePassword.Title".localized)
				.font(AppTheme.shared.fontSet.font(style: .body2))
				.foregroundColor(foregroundBackButton)
				.frame(maxWidth: .infinity, alignment: .leading)
			SecureTextField(secureText: $currentPassword,
							inputStyle: $currentStyle,
							inputIcon: AppTheme.shared.imageSet.lockIcon,
							placeHolder: "ChangePassword.CurrentPassword".localized,
							keyboardType: .default,
							onEditingChanged: { isEditing in
				if isEditing {
					currentStyle = .highlighted
				} else {
					currentStyle = .normal
				}
			})
			SecureTextField(secureText: $newPassword,
							inputStyle: $newStyle,
							inputIcon: AppTheme.shared.imageSet.lockIcon,
							placeHolder: "ChangePassword.NewPassword".localized,
							keyboardType: .default,
							onEditingChanged: { isEditing in
				if isEditing {
					newStyle = .highlighted
				} else {
					newStyle = .normal
				}
			})
			SecureTextField(secureText: $confirmPassword,
							inputStyle: $confirmStyle,
							inputIcon: AppTheme.shared.imageSet.lockIcon,
							placeHolder: "General.ConfirmPassword".localized,
							keyboardType: .default,
							onEditingChanged: { isEditing in
				if isEditing {
					confirmStyle = .highlighted
				} else {
					confirmStyle = .normal
				}
			})
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
				Text("ChangePassword.TitleButton".localized)
					.padding(.all)
					.font(AppTheme.shared.fontSet.font(style: .body2))
			}
			.foregroundColor(foregroundBackButton)
		}
	}
	
	var buttonSave: some View {
		Button {
			dochangPassword()
		} label: {
			Text("ChangePassword.Save".localized)
				.frame(maxWidth: .infinity, alignment: .center)
				.padding(.all, Constants.padding)
				.background(backgroundButton)
				.foregroundColor(foregroundButton)
		}
		.cornerRadius(Constants.radius)
	}
}

// MARK: - Interactor

// MARK: - Preview
#if DEBUG
struct ChangePasswordContentView_Previews: PreviewProvider {
	static var previews: some View {
		ChangePasswordContentView()
	}
}
#endif
