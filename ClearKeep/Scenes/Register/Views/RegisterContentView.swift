//
//  RegisterContentView.swift
//  ClearKeep
//
//  Created by MinhDev on 04/03/2022.
//

import SwiftUI
import CommonUI

private enum Constants {
	static let radius = 32.0
	static let radiusButton = 20.0
	static let sapcing = 20.0
	static let padding = 10.0
	static let paddingHorizoltal = 40.0
}

struct RegisterContentView: View {
	// MARK: - Variables
	@Environment(\.colorScheme) var colorScheme
	@Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
	@Binding var email: String
	@Binding var password: String
	@Binding var displayname: String
	@Binding var rePassword: String
	@Binding var emailStyle: TextInputStyle
	@Binding var nameStyle: TextInputStyle
	@Binding var passwordStyle: TextInputStyle
	@Binding var rePasswordStyle: TextInputStyle

	// MARK: - Body
	var body: some View {
		VStack(alignment: .center, spacing: Constants.sapcing) {
			Text("Register.Title".localized)
				.font(AppTheme.shared.fontSet.font(style: .body1))
				.frame(maxWidth: .infinity, alignment: .leading)
				.padding(.all, Constants.padding)
			nomalTextfield
			secureTexfield
			button
		}
		.padding(.all, Constants.padding)
		.background(RoundedRectangle(cornerRadius: Constants.radius).fill(backgroundColorView))
		.frame(maxWidth: .infinity, alignment: .center)
	}
}

// MARK: - Private variables
private extension RegisterContentView {
	var backgroundColorButton: LinearGradient {
		(email.isEmpty || password.isEmpty || displayname.isEmpty || rePassword.isEmpty) ? backgroundColorUnActive : backgroundColorActive
	}

	var backgroundColorActive: LinearGradient {
		LinearGradient(gradient: Gradient(colors: AppTheme.shared.colorSet.gradientLinear), startPoint: .leading, endPoint: .trailing)
	}

	var backgroundColorUnActive: LinearGradient {
		LinearGradient(gradient: Gradient(colors: AppTheme.shared.colorSet.gradientLinear.compactMap({ $0.opacity(0.5) })), startPoint: .leading, endPoint: .trailing)
	}

	var backgroundColorView: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.offWhite : AppTheme.shared.colorSet.grey6
	}

	var foregroundColorWhite: Color {
		AppTheme.shared.colorSet.offWhite
	}

	var foregroundColorPrimary: Color {
		AppTheme.shared.colorSet.primaryDefault
	}
}

// MARK: - Private func
private extension RegisterContentView {
	func customBack() {
		self.presentationMode.wrappedValue.dismiss()
	}

	func register() {
		self.presentationMode.wrappedValue.dismiss()
	}

	func buttonStatus() -> Bool {
		email.isEmpty || password.isEmpty || displayname.isEmpty || rePassword.isEmpty
	}
}
// MARK: - Private
private extension RegisterContentView {

	var button: AnyView {
		AnyView(buttonView)
	}

	var secureTexfield: AnyView {
		AnyView(secureView)
	}

	var nomalTextfield: AnyView {
		AnyView(nomalTextfieldView)
	}
}

// MARK: - Loading Content
private extension RegisterContentView {
	var buttonView: some View {
		HStack {
			Button(action: customBack) {
				Text("Register.SignInInstead".localized)
					.padding(.all)
					.font(AppTheme.shared.fontSet.font(style: .body4))
					.foregroundColor(foregroundColorPrimary)
			}
			Spacer()
			Button(action: register) {
				Text("Register.SignUp".localized)
					.padding(.vertical, Constants.padding)
					.padding(.horizontal, Constants.paddingHorizoltal)
					.background(backgroundColorButton)
					.foregroundColor(foregroundColorWhite)
			}
			.disabled(buttonStatus())
			.cornerRadius(Constants.radiusButton)
		}
	}
	var secureView: some View {
		VStack(spacing: Constants.sapcing) {
			SecureTextField(secureText: $password,
							inputStyle: $passwordStyle,
							inputIcon: AppTheme.shared.imageSet.lockIcon,
							placeHolder: "General.Password".localized,
							keyboardType: .default)
			SecureTextField(secureText: $rePassword,
							inputStyle: $rePasswordStyle,
							inputIcon: AppTheme.shared.imageSet.lockIcon,
							placeHolder: "General.ConfirmPassword".localized,
							keyboardType: .default)
		}
	}

	var nomalTextfieldView: some View {
		VStack(spacing: Constants.sapcing) {
			CommonTextField(text: $email,
							inputStyle: $emailStyle,
							inputIcon: AppTheme.shared.imageSet.mailIcon,
							placeHolder: "General.Email".localized,
							keyboardType: .default,
							onEditingChanged: { isEditing in
				if isEditing {
					emailStyle = .highlighted
				} else {
					emailStyle = .normal
				}
			})
			CommonTextField(text: $displayname,
							inputStyle: $nameStyle,
							inputIcon: AppTheme.shared.imageSet.userCheckIcon,
							placeHolder: "General.DisplayName".localized,
							keyboardType: .default,
							onEditingChanged: { isEditing in
				if isEditing {
					nameStyle = .highlighted
				} else {
					nameStyle = .normal
				}
			})
		}
	}
}

// MARK: - Preview
#if DEBUG
struct RegisterContentView_Previews: PreviewProvider {
	static var previews: some View {
		RegisterContentView(email: .constant("Test"), password: .constant("Test"), displayname: .constant("Test"), rePassword: .constant("Test"), emailStyle: .constant(.default), nameStyle: .constant(.default), passwordStyle: .constant(.default), rePasswordStyle: .constant(.default))
	}
}
#endif
