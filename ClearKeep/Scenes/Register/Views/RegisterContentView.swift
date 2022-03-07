//
//  RegisterContentView.swift
//  ClearKeep
//
//  Created by MinhDev on 04/03/2022.
//

import SwiftUI
import CommonUI
import RealmSwift
import SwiftUIX

private enum Constants {
	static let width = 120.0
	static let height = 40.0
	static let radius = 20.0
	static let sapcing = 20.0
}

struct RegisterContentView: View {
	// MARK: - Variables
	@Environment(\.colorScheme) var colorScheme
	@Binding var username: String
	@Binding var password: String
	@Binding var displayname: String
	@Binding var rePassword: String
	@Binding var inputStyle: TextInputStyle
	// MARK: - Body
	var body: some View {
		GroupBox(label:
					Text("Register.Title".localized)
					.font(AppTheme.shared.fontSet.font(style: .body1))) {
			VStack(alignment: .center, spacing: Constants.sapcing) {
				nomalTextfield
				secureTexfield
				button
			}
		}
	}
}

// MARK: - Private variables
private extension RegisterContentView {
	var backgroundColorView: LinearGradient {
		LinearGradient(gradient: Gradient(colors: backgroundColorButton), startPoint: .leading, endPoint: .trailing)
	}
	var backgroundColorButton: [Color] {
		AppTheme.shared.colorSet.gradientPrimary
	}

	var foregroundColorWhite: Color {
		AppTheme.shared.colorSet.offWhite
	}

	var foregroundColorPrimary: Color {
		AppTheme.shared.colorSet.primaryDefault
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
			Button("Register.SignInInstead".localized) {
			}
			.foregroundColor(foregroundColorPrimary)
			Spacer()
			Button("Register.SignUp".localized) {
			}
			.frame(width: Constants.width, height: Constants.height)
			.background(backgroundColorView)
			.foregroundColor(foregroundColorWhite)
			.cornerRadius(Constants.radius)
		}
	}
	
	var secureView: some View {
		VStack(spacing: Constants.sapcing) {
			SecureTextField(secureText: $password,
							inputStyle: $inputStyle,
							inputIcon: AppTheme.shared.imageSet.lockIcon,
							placeHolder: "General.Password".localized,
							keyboardType: .default )
			SecureTextField(secureText: $rePassword,
							inputStyle: $inputStyle,
							inputIcon: AppTheme.shared.imageSet.lockIcon,
							placeHolder: "General.ConfirmPassword".localized,
							keyboardType: .default )
		}
	}
	
	var nomalTextfieldView: some View {
		VStack(spacing: Constants.sapcing) {
			CommonTextField(text: $username,
							inputStyle: $inputStyle,
							inputIcon: AppTheme.shared.imageSet.mailIcon,
							placeHolder: "General.Email".localized,
							keyboardType: .default,
							onEditingChanged: { isEditing in
				if isEditing {
					inputStyle = .default
				} else {
					inputStyle = .normal
				}
			})
			CommonTextField(text: $displayname,
							inputStyle: $inputStyle,
							inputIcon: AppTheme.shared.imageSet.userIcon,
							placeHolder: "General.Displayname".localized,
							keyboardType: .default,
							onEditingChanged: { isEditing in
				if isEditing {
					inputStyle = .highlighted
				} else {
					inputStyle = .normal
				}
			})
		}
	}
}
// MARK: - Preview
#if DEBUG
struct RegisterContentView_Previews: PreviewProvider {
	static var previews: some View {
		RegisterContentView(username: .constant("Test"), password: .constant("Test"), displayname: .constant("Test"), rePassword: .constant("Test"), inputStyle: .constant(.default))
	}
}
#endif
