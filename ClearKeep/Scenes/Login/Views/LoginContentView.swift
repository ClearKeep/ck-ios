//
//  LoginView.swift
//  ClearKeep
//
//  Created by đông on 02/03/2022.
//
import SwiftUI
import CommonUI

private enum Constant {
	static let spacerTopView = 50.0
	static let spacerBottomView = 15.0
	static let spacer = 25.0
	static let widthLogo = 160.0
	static let heightLogo = 120.0
	static let widthSignInBt = UIScreen.main.bounds.width - 30.0
	static let widthSignUpBt = UIScreen.main.bounds.width - 30.0
	static let widthIconBt = 54.0
	static let heightBt = 40.0
	static let radius = 40.0
	static let heightRectangle = 1.0
	static let lineWidthBorder = 4.0
}

struct LoginContentView: View {
	@State private var email: String = ""
	@State private var password: String = ""
	@State private var editingEmail = false
	@State private var editingPassword = false
	var appTheme: AppTheme = .shared
	@State var inputStyle: TextInputStyle  = .normal
	@Environment(\.colorScheme) var colorScheme

	var body: some View {
		ScrollView {
			backgroundColorView
					VStack {
						Spacer(minLength: Constant.spacerTopView)

					// MARK: - Logo
					imageLogo
						.resizable()
						.aspectRatio(contentMode: .fit)
						.frame(width: Constant.widthLogo, height: Constant.heightLogo)

					Spacer(minLength: Constant.spacerTopView)

					// MARK: - Text Input
						VStack {
							CommonTextField(text: $email, inputStyle: $inputStyle, inputIcon: iconMail, placeHolder: "General.Email".localized, keyboardType: .default, onEditingChanged: { isEditing in
												if isEditing {
													inputStyle = .normal
												} else {
													inputStyle = .highlighted
												}
											})

							Spacer(minLength: Constant.spacer)

							SecureTextField(secureText: $password, inputStyle: $inputStyle, inputIcon: iconLock, placeHolder: "General.Password".localized, keyboardType: .default )
						}
					Spacer(minLength: Constant.spacer)

					// MARK: - Signin button
						Button("Login.SignIn".localized) {}
						.frame(width: Constant.widthSignInBt, height: Constant.heightBt)
						.font(fontSignIn)
						.background(backgroundSignInBt)
						.foregroundColor(foregroundColorView)
						.cornerRadius(Constant.radius)

					// MARK: - Support Button
					HStack {
						Button("Login.AdvancedServerSettings".localized) {}
							.padding()
							.font(fontSignIn)
							.foregroundColor(foregroundColorViewBt)

						Spacer()

						Button("Login.ForgotPassword?".localized) {}
							.padding()
							.font(fontSignIn)
							.foregroundColor(foregroundColorViewBt)
					}
				}
					Spacer(minLength: Constant.spacer)
				// MARK: - Line between 2 views
					Rectangle().frame(height: Constant.heightRectangle)
						.padding(.horizontal).foregroundColor(foregroundColorWhite)

					Spacer(minLength: Constant.spacer)

				// MARK: - Social login button
					VStack {
						Text("Login.SignInWith".localized)
							.font(fontSignIn)
							.foregroundColor(foregroundColorWhite)

						HStack {
							Button(action: { }, label: {
								Text("")
								iconGoogle
							})
								.frame(width: Constant.widthIconBt, height: Constant.widthIconBt)
								.padding()

							Button(action: { }, label: {
								Text("")
								iconOffice
							})
								.frame(width: Constant.widthIconBt, height: Constant.widthIconBt)
								.padding()

							Button(action: { }, label: {
								Text("")
								iconFacebook
							})
								.frame(width: Constant.widthIconBt, height: Constant.widthIconBt)
								.padding()
						}.padding(.horizontal)
						Spacer(minLength: Constant.spacer)

						// MARK: - Sign up button
						Text("Login.Don'tHaveAnAccount?".localized)
							.font(fontSignIn)
							.foregroundColor(foregroundColorWhite)

						Spacer(minLength: Constant.spacer)

						Button("Login.SignUp".localized) {}
						.frame(width: Constant.widthSignUpBt, height: Constant.heightBt)
							.font(fontSignIn)
							.foregroundColor(foregroundColorViewBt)
							.overlay(
								RoundedRectangle(cornerRadius: Constant.radius)
									.stroke(foregroundColorViewBt, lineWidth: Constant.lineWidthBorder))

						Spacer(minLength: Constant.spacerBottomView)

						Text("Login.AppVersion:1.1.1".localized)
							.font(appTheme.fontSet.font(style: .placeholder3))
							.foregroundColor(foregroundColorWhite)
					}

		}
		.background(backgroundColorView)
		.edgesIgnoringSafeArea(.all)
	}
}

// MARK: - Private func
private extension LoginContentView {
	var imageLogo: Image {
		AppTheme.shared.imageSet.logo
	}

	var iconLock: Image {
		AppTheme.shared.imageSet.lockIcon
	}

	var iconMail: Image {
		AppTheme.shared.imageSet.mailIcon
	}

	var iconGoogle: Image {
		AppTheme.shared.imageSet.googleIcon
	}

	var iconOffice: Image {
		AppTheme.shared.imageSet.officeIcon
	}

	var iconFacebook: Image {
		AppTheme.shared.imageSet.facebookIcon
	}

	var backgroundColorView: LinearGradient {
		colorScheme == .light ? backgroundColorGradient : backgroundColorDark
	}

	var backgroundSignInBt: LinearGradient {
		colorScheme == .light ? backgroundColorWhite : backgroundColorGradient
	}

	var foregroundColorView: Color {
		colorScheme == .light ? foregroundColorPrimary : foregroundColorWhite
	}

	var foregroundColorViewBt: Color {
		colorScheme == .light ? foregroundColorWhite : foregroundColorPrimary
	}

	var foregroundColorWhite: Color {
		AppTheme.shared.colorSet.offWhite
	}

	var foregroundColorPrimary: Color {
		AppTheme.shared.colorSet.primaryDefault
	}

	var foregroundColorGradient: LinearGradient {
		LinearGradient(gradient: Gradient(colors: [.white, .white]), startPoint: .leading, endPoint: .trailing)
	}

	var backgroundColorWhite: LinearGradient {
		LinearGradient(gradient: Gradient(colors: [.white, .white]), startPoint: .leading, endPoint: .trailing)
	}

	var backgroundColorDark: LinearGradient {
		LinearGradient(gradient: Gradient(colors: [.black, .black]), startPoint: .leading, endPoint: .trailing)
	}

	var backgroundColorGradient: LinearGradient {
		LinearGradient(gradient: Gradient(colors: AppTheme.shared.colorSet.gradientPrimary), startPoint: .leading, endPoint: .trailing)
	}

	var fontSignIn: Font {
		AppTheme.shared.fontSet.font(style: .body3)
	}
}

#if DEBUG
struct LoginContentView_Previews: PreviewProvider {
	static var previews: some View {
		LoginContentView()
	}
}
#endif
