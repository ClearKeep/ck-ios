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
}

struct RegisterContentView: View {
// MARK: - Variables
	@Environment(\.colorScheme) var colorScheme
	@State var username: String
	@State var password: String
	@State var displayname: String
	@State var rePassword: String
	@State var focused: Bool = false
	@State var appTheme: AppTheme
	@State var inputStyle: TextInputStyle
// MARK: - Body
	var body: some View {
		GroupBox(label:
					Text("Please fill in the information below to complete your sign up")
					.font(appTheme.fontSet.font(style: .body1))) {
			VStack(alignment: .center, spacing: 20.0) {
				CommonTextField(text: $username, inputStyle: $inputStyle, inputIcon: appTheme.imageSet.mailIcon, placeHolder: "email", keyboardType: .default, onEditingChanged: { isEditing in
					if isEditing {
						inputStyle = .normal
					} else {
						inputStyle = .highlighted
					}
				})
				CommonTextField(text: $displayname, inputStyle: $inputStyle, inputIcon: appTheme.imageSet.userIcon, placeHolder: "DisplayName", keyboardType: .default, onEditingChanged: { isEditing in
					if isEditing {
						inputStyle = .highlighted
					} else {
						inputStyle = .normal
					}
				})
				SecureTextField(secureText: $password, inputStyle: $inputStyle, inputIcon: appTheme.imageSet.lockIcon, placeHolder: "Password", keyboardType: .default )
				SecureTextField(secureText: $password, inputStyle: $inputStyle, inputIcon: appTheme.imageSet.lockIcon, placeHolder: "RePassword", keyboardType: .default )
				HStack {
					Button("Sign in instead") {

					}.foregroundColor(appTheme.colorSet.primaryDefault)
					Spacer()
					Button("Sign up") {

					}
					.frame(width: Constants.width, height: Constants.height)
					.background(appTheme.colorSet.primaryDefault)
					.foregroundColor(appTheme.colorSet.offWhite)
					.cornerRadius(Constants.radius)
				}
			}
		}
	}
}

// MARK: - Preview
struct RegisterContentView_Previews: PreviewProvider {
	static var previews: some View {
		RegisterContentView(username: "Test", password: "123", displayname: "Minh", rePassword: "123", appTheme: .shared, inputStyle: .normal)

	}
}
