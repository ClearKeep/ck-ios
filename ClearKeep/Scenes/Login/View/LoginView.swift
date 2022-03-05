//
//  LoginView.swift
//  ClearKeep
//
//  Created by đông on 02/03/2022.
//

import SwiftUI
import CommonUI

struct LoginView: View {
	@State private var email: String = ""
	@State private var password: String = ""
	@State private var editingEmail = false
	@State private var editingPassword = false
	private var image: IAppImageSet = AppImageSet()
	var colorStyle: IColorSet = ColorSet()
	var fontStyle: IFontSet = DefaultFontSet()
	@Environment(\.colorScheme) var colorScheme
	
    var body: some View {
		ScrollView {
			colorScheme == .light ? Color(colorStyle.primary) : Color(colorStyle.gray3Dark)
				VStack() {
					Spacer(minLength: 50)
					// Logo
					Image(uiImage: image.logo)
						.resizable()
						.aspectRatio(contentMode: .fit)
						.frame(width: 150.0, height: 150.0)

					Spacer(minLength: 50)

					//Text Input
						VStack {
							TextField("Email", text: $email, onEditingChanged: { edit in
								self.editingEmail = edit
							   })
								.modifier(NormalTextField(image: image.mailIcon, focused: $editingEmail))

							Spacer(minLength: 25)

							TextField("Password", text: $password, onEditingChanged: { edit in
								self.editingPassword = edit
							   })
								.modifier(PasswordTextField(image: image.lockIcon, focused: $editingPassword))
						}

					Spacer(minLength: 25)

					//Button
					Button("Sign in") {}
					.buttonStyle(PrimaryButton())

					//Button
					HStack {
						Button("Advanced Server Settings") {}
						.buttonStyle(TextButton())
						Spacer()
						Button("Forgot password?") {}
						.buttonStyle(TextButton())
					}
				}
					Spacer(minLength: 30)

					Rectangle().frame(height: 1)
						.padding(.horizontal, 20).foregroundColor(Color(colorStyle.offWhite))

					Spacer(minLength: 30)

				//Social login button
					VStack {
						Text("Sign in with")
							.font(Font(fontStyle.font(style: .linkL)))
							.foregroundColor(colorScheme == .light ? Color(colorStyle.offWhite) : Color(colorStyle.primary))

						HStack {
							Button(action: { }, label: {
								Text("")
							}).buttonStyle(IconButton(image: image.googleIcon))

							Button(action: { }, label: {
								Text("")
							}).buttonStyle(IconButton(image: image.officeIcon))

							Button(action: { }, label: {
								Text("")
							}).buttonStyle(IconButton(image: image.facebookIcon))
						}.padding(.horizontal)

						Spacer(minLength: 25.0)

							//Sign up button
						Text("Don't have an account?")
							.font(Font(fontStyle.font(style: .linkL)))
							.foregroundColor(colorScheme == .light ? Color(colorStyle.offWhite) : Color(colorStyle.primary))

						Spacer(minLength: 20.0)

						Button("Sign up") {}
						.buttonStyle(BoderButton())

						Spacer(minLength: 15.0)

						Text("App version: 1.1.1")
							.font(Font(fontStyle.font(style: .linkXS)))
							.foregroundColor(colorScheme == .light ? Color(colorStyle.offWhite) : Color(colorStyle.primary))
					}

		}
		.background(colorScheme == .light ? Color(colorStyle.primary) : Color(colorStyle.gray3Dark))
		.edgesIgnoringSafeArea(.all)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
			LoginView()
    }
}
