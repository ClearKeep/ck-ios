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
	var appTheme: AppTheme = .shared
	@State var inputStyle: TextInputStyle  = .normal
	@Environment(\.colorScheme) var colorScheme
	
	var body: some View {
		ScrollView {
			colorScheme == .light ? appTheme.colorSet.primaryDefault : appTheme.colorSet.black
					VStack {
					Spacer(minLength: 50)

					// MARK: - Logo
					appTheme.imageSet.logo
						.resizable()
						.aspectRatio(contentMode: .fit)
						.frame(width: 150.0, height: 150.0)

					Spacer(minLength: 50)

					// MARK: - Text Input
						VStack {
							CommonTextField(text: $email, inputStyle: $inputStyle, inputIcon: appTheme.imageSet.mailIcon, placeHolder: "email", keyboardType: .default, onEditingChanged: { isEditing in
												if isEditing {
													inputStyle = .normal
												} else {
													inputStyle = .highlighted
												}
											})

							Spacer(minLength: 25)

							SecureTextField(secureText: $password, inputStyle: $inputStyle, inputIcon: appTheme.imageSet.lockIcon, placeHolder: "Password", keyboardType: .default )
						}
					Spacer(minLength: 25)

					// MARK: - Signin button
					Button("Sign in") {}
						.frame(width: UIScreen.main.bounds.width - 30.0, height: 40.0)
						.font(appTheme.fontSet.font(style: .display1))
						.background(colorScheme == .light ? appTheme.colorSet.offWhite : appTheme.colorSet.primaryDefault)
						.foregroundColor(colorScheme == .light ? appTheme.colorSet.primaryDefault : appTheme.colorSet.offWhite)
						.cornerRadius(40.0)

					// MARK: - Support Button
					HStack {
						Button("Advanced Server Settings") {}
							.padding()
							.font(appTheme.fontSet.font(style: .display2))
							.foregroundColor(colorScheme == .light ? appTheme.colorSet.offWhite : appTheme.colorSet.primaryDefault)

						Spacer()

						Button("Forgot password?") {}
							.padding()
							.font(appTheme.fontSet.font(style: .display2))
							.foregroundColor(colorScheme == .light ? appTheme.colorSet.offWhite : appTheme.colorSet.primaryDefault)
					}
				}
					Spacer(minLength: 30)
				// MARK: - Line between 2 views
					Rectangle().frame(height: 1)
				.padding(.horizontal, 20).foregroundColor(appTheme.colorSet.offWhite)

					Spacer(minLength: 30)

				// MARK: - Social login button
					VStack {
						Text("Sign in with")
//							.font(Font(fontStyle.font(style: .linkL)))
							.foregroundColor(colorScheme == .light ? appTheme.colorSet.offWhite : appTheme.colorSet.offWhite)

						HStack {
							Button(action: { }, label: {
								Text("")
								appTheme.imageSet.googleIcon
							})
								.frame(width: 54.0, height: 54.0)
								.padding()

							Button(action: { }, label: {
								Text("")
								appTheme.imageSet.officeIcon
							})
								.frame(width: 54.0, height: 54.0)
								.padding()

							Button(action: { }, label: {
								Text("")
								appTheme.imageSet.facebookIcon
							})
								.frame(width: 54.0, height: 54.0)
								.padding()
						}.padding(.horizontal)
						Spacer(minLength: 25.0)

						// MARK: - Sign up button

						Text("Don't have an account?")
							.font(appTheme.fontSet.font(style: .display2))
							.foregroundColor(colorScheme == .light ? appTheme.colorSet.offWhite : appTheme.colorSet.offWhite)

						Spacer(minLength: 20.0)

						Button("Sign up") {}
							.frame(width: UIScreen.main.bounds.width - 80.0, height: 40.0)
							.font(appTheme.fontSet.font(style: .display2))
							.foregroundColor(colorScheme == .light ? appTheme.colorSet.offWhite : appTheme.colorSet.primaryDefault)
							.overlay(
								RoundedRectangle(cornerRadius: 40.0)
									.stroke(colorScheme == .light ? appTheme.colorSet.offWhite : appTheme.colorSet.primaryDefault, lineWidth: 4))

						Spacer(minLength: 15.0)

						Text("App version: 1.1.1")
							.font(appTheme.fontSet.font(style: .display1))
							.foregroundColor(colorScheme == .light ? appTheme.colorSet.offWhite : appTheme.colorSet.offWhite)
					}

		}
		.background(colorScheme == .light ? appTheme.colorSet.primaryDefault : appTheme.colorSet.black)
		.edgesIgnoringSafeArea(.all)
	}
}

#if DEBUG
struct LoginView_Previews: PreviewProvider {
	static var previews: some View {
		LoginView()
	}
}
#endif
