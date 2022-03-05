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
	static let width = 300.0
	static let height = 500.0
	static let notifyHeight = 20.0
}

struct RegisterContentView: View {
	// MARK: - Variables
	@State var username: String
	@State var password: String
	@State var displayname: String
	@State var rePassword: String
	@State var focused: Bool = false
	@State var imageIcon: IAppImageSet = AppImageSet()
	@State var inputStyle: TextInputStyle
	@State var fontStyle: IFontSet = DefaultFontSet()
	var bgm: IColorSet = ColorSet()
	// MARK: - Body
	var body: some View {
		GroupBox(label:
					Text("Please fill in the information below to complete your sign up")
					.font(fontStyle.font(style: .body1))) {
			VStack(alignment: .center, spacing: 20.0) {
				CommonTextField(text: $username, inputStyle: $inputStyle, focused: $focused, placeHolder: "Email", onEditingChanged: { isEditing in
					if isEditing {
						inputStyle = .normal
					} else {
						inputStyle = .highlighted
					}
				})

				CommonTextField(text: $displayname, inputStyle: $inputStyle, focused: $focused, placeHolder: "Email", onEditingChanged: { isEditing in
					if isEditing {
						inputStyle = .highlighted
					} else {
						inputStyle = .normal
					}
				})
				SecureTextField(text: $password, inputStyle: $inputStyle, placeHolder: "Password")
				SecureTextField(text: $password, inputStyle: $inputStyle, placeHolder: "Confirm Password")
			}

		}
					.frame(width: UIScreen.main.bounds.width - 20, height: 400, alignment: .center)
		
	}
}
struct RegisterContentView_Previews: PreviewProvider {
	static var previews: some View {
		RegisterContentView(username: "Test", password: "123", displayname: "Minh", rePassword: "123", inputStyle: .normal)

	}
}
