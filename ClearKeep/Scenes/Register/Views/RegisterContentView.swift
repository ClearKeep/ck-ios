//
//  RegisterContentView.swift
//  ClearKeep
//
//  Created by MinhDev on 04/03/2022.
//

import SwiftUI
import CommonUI
import RealmSwift

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
					Text("Register.Please fill in the information below to complete your sign up".localized)
					.font(fontTitle)) {
			VStack(alignment: .center, spacing: Constants.sapcing) {
				CommonTextField(text: $username,
								inputStyle: $inputStyle,
								inputIcon: iconMail,
								placeHolder: "General.Email".localized,
								keyboardType: .default,
								onEditingChanged: { isEditing in
					if isEditing {
						inputStyle = .normal
					} else {
						inputStyle = .highlighted
					}
				})
				CommonTextField(text: $displayname,
								inputStyle: $inputStyle,
								inputIcon: iconUser,
								placeHolder: "General.Displayname".localized,
								keyboardType: .default,
								onEditingChanged: { isEditing in
					if isEditing {
						inputStyle = .highlighted
					} else {
						inputStyle = .normal
					}
				})
				SecureTextField(secureText: $password,
								inputStyle: $inputStyle,
								inputIcon: iconSecure,
								placeHolder: "General.Password".localized,
								keyboardType: .default )
				SecureTextField(secureText: $password,
								inputStyle: $inputStyle,
								inputIcon: iconSecure,
								placeHolder: "General.Confirm Password".localized,
								keyboardType: .default )
				HStack {
					Button("Register.Sign in instead".localized) {

					}
					.foregroundColor(foregroundColorPrimary)
					Spacer()
					Button("Register.Sign up".localized) {

					}
					.frame(width: Constants.width, height: Constants.height)
					.background(LinearGradient(gradient: Gradient(colors: backgroundColorButton), startPoint: .leading, endPoint: .trailing))
					.foregroundColor(foregroundColorWhite)
					.cornerRadius(Constants.radius)
				}
			}
		}
	}
}

// MARK: - Private func
private extension RegisterContentView {
	var backgroundColorButton: [Color] {
		AppTheme.shared.colorSet.gradientPrimary
	}

	var foregroundColorWhite: Color {
		AppTheme.shared.colorSet.offWhite
	}

	var foregroundColorPrimary: Color {
		AppTheme.shared.colorSet.primaryDefault
	}

	var iconSecure: Image {
		AppTheme.shared.imageSet.lockIcon
	}

	var iconUser: Image {
		AppTheme.shared.imageSet.userIcon
	}

	var iconMail: Image {
		AppTheme.shared.imageSet.mailIcon
	}

	var fontTitle: Font {
		AppTheme.shared.fontSet.font(style: .body1)
	}
}
// MARK: - Preview
struct RegisterContentView_Previews: PreviewProvider {
	static var previews: some View {
		RegisterContentView(username: .constant("Test"), password: .constant("Test"), displayname: .constant("Test"), rePassword: .constant("Test"), inputStyle: .constant(.default))
	}
}
