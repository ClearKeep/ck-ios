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
	static let spacerBottomView = 20.0
	static let spacer = 25.0
	static let spacerBottom = 45.0
	static let widthLogo = 160.0
	static let heightLogo = 120.0
	static let paddingVertical = 14.0
	static let paddingHorizontal = 24.0
	static let paddingHorizontalSignUp = 60.0
	static let widthIconButton = 54.0
	static let heightButton = 40.0
	static let radius = 40.0
	static let heightRectangle = 1.0
	static let lineWidthBorder = 3.0
}

struct LoginContentView: View {
	@Binding var email: String
	@Binding var password: String
	@Binding var emailStyle: TextInputStyle
	@Binding var passwordStyle: TextInputStyle
	@State private var editingEmail = false
	@State private var editingPassword = false
	@Environment(\.colorScheme) var colorScheme
	
	var body: some View {
		VStack(alignment: .center, spacing: Constant.spacer) {
			textInput
			button
			extraButton
			lineSeperate
			signInWith
			socialLoginButton
			signUp
		}
	}
}

// MARK: - Private
private extension LoginContentView {
	
	var button: AnyView {
		AnyView(buttonSignIn)
	}
	
	var textInput: AnyView {
		AnyView(textInputView)
	}
	
	var extraButton: AnyView {
		AnyView(extraButtonView)
	}
	
	var lineSeperate: AnyView {
		AnyView(lineSeperateView)
	}
	
	var signInWith: AnyView {
		AnyView(signInWithView)
	}
	
	var socialLoginButton: AnyView {
		AnyView(socialLoginButtonView)
	}
	
	var signUp: AnyView {
		AnyView(signUpView)
	}
}

// MARK: - Loading Content
private extension LoginContentView {
	var buttonSignIn: some View {
		Button("Login.SignIn".localized) {}
		.frame(maxWidth: .infinity)
		.frame(height: Constant.heightButton)
		.font(fontSignIn)
		.background(backgroundSignInButton)
		.foregroundColor(foregroundColorView)
		.cornerRadius(Constant.radius)
	}
	
	var textInputView: some View {
		VStack(spacing: Constant.spacer) {
			CommonTextField(text: $email,
							inputStyle: $emailStyle,
							inputIcon: AppTheme.shared.imageSet.mailIcon,
							placeHolder: "General.Email".localized,
							keyboardType: .default,
							onEditingChanged: { isEditing in
				if isEditing {
					emailStyle = .normal
				} else {
					emailStyle = .highlighted
				}
			})
			SecureTextField(secureText: $password,
							inputStyle: $passwordStyle,
							inputIcon: AppTheme.shared.imageSet.lockIcon,
							placeHolder: "General.Password".localized,
							keyboardType: .default )
		}
	}
	
	var extraButtonView: some View {
		HStack {
			Button("Login.AdvancedServerSettings".localized) {}
			.padding()
			.font(fontSignIn)
			.foregroundColor(foregroundColorViewButton)
			
			Spacer()
			
			Button("Login.ForgotPassword?".localized) {}
			.padding()
			.font(fontSignIn)
			.foregroundColor(foregroundColorViewButton)
		}
	}
	
	var lineSeperateView: some View {
		Rectangle().frame(height: Constant.heightRectangle)
			.padding(.horizontal).foregroundColor(foregroundColorWhite)
	}
	
	var signInWithView: some View {
		Text("Login.SignInWith".localized)
			.font(fontSignIn)
			.foregroundColor(foregroundColorWhite)
	}
	
	var socialLoginButtonView: some View {
		HStack(spacing: Constant.spacerBottom) {
			NavigationLink(destination: SocialView(security: "")) {
				AppTheme.shared.imageSet.googleIcon
			}
			
			NavigationLink(destination: SocialView(security: "")) {
				AppTheme.shared.imageSet.officeIcon
			}
			
			NavigationLink(destination: SocialView(security: "")) {
				AppTheme.shared.imageSet.facebookIcon
			}
		}
		.frame(maxWidth: .infinity)
		.padding(.leading, Constant.paddingHorizontalSignUp)
		.padding(.trailing, Constant.paddingHorizontalSignUp)
	}
	
	var signUpView: some View {
		VStack {
			Text("Login.SignUp.Suggest".localized)
				.font(fontSignIn)
				.foregroundColor(foregroundColorWhite)
			
			Spacer(minLength: Constant.spacer)
			
			Button("Login.SignUp".localized) {}
			.frame(maxWidth: .infinity)
			.frame(height: Constant.heightButton)
			.font(fontSignIn)
			.foregroundColor(foregroundColorViewButton)
			.overlay(
				RoundedRectangle(cornerRadius: Constant.radius)
					.stroke(foregroundColorViewButton, lineWidth: Constant.lineWidthBorder))
			
			Spacer(minLength: Constant.spacerBottomView)
			
			Text("Login.Version".localized)
				.font(AppTheme.shared.fontSet.font(style: .placeholder3))
				.foregroundColor(foregroundColorWhite)
		}
		.padding(.leading, Constant.paddingHorizontalSignUp)
		.padding(.trailing, Constant.paddingHorizontalSignUp)
	}
}

// MARK: - Private func
private extension LoginContentView {
	var backgroundColorView: LinearGradient {
		colorScheme == .light ? backgroundColorGradient : backgroundColorDark
	}
	
	var backgroundSignInButton: LinearGradient {
		colorScheme == .light ? backgroundColorWhite : backgroundColorGradient
	}
	
	var foregroundColorView: Color {
		colorScheme == .light ? foregroundColorPrimary : foregroundColorWhite
	}
	
	var foregroundColorViewButton: Color {
		colorScheme == .light ? foregroundColorWhite : foregroundColorPrimary
	}
	
	var foregroundColorWhite: Color {
		AppTheme.shared.colorSet.offWhite
	}
	
	var foregroundColorPrimary: Color {
		AppTheme.shared.colorSet.primaryDefault
	}
	
	var foregroundColorGradient: LinearGradient {
		LinearGradient(gradient: Gradient(colors: [AppTheme.shared.colorSet.offWhite, AppTheme.shared.colorSet.offWhite]), startPoint: .leading, endPoint: .trailing)
	}
	
	var backgroundColorWhite: LinearGradient {
		LinearGradient(gradient: Gradient(colors: [AppTheme.shared.colorSet.offWhite, AppTheme.shared.colorSet.offWhite]), startPoint: .leading, endPoint: .trailing)
	}
	
	var backgroundColorDark: LinearGradient {
		LinearGradient(gradient: Gradient(colors: [AppTheme.shared.colorSet.black, AppTheme.shared.colorSet.black]), startPoint: .leading, endPoint: .trailing)
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
		LoginContentView(email: .constant("Test"), password: .constant("Test"), emailStyle: .constant(.default), passwordStyle: .constant(.default))
	}
}
#endif
