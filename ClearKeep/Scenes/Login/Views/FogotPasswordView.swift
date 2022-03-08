//
//  FogotPasswordView.swift
//  ClearKeep
//
//  Created by MinhDev on 05/03/2022.
//
import SwiftUI
import CommonUI
import Common

private enum Constants {
	static let width = UIScreen.main.bounds.width - 20.0
	static let height = 40.0
	static let radius = 40.0
	static let spacing = 20.0
}

struct FogotPasswordView: View {
	// MARK: - Constants
	private let inspection = ViewInspector<Self>()
	
	// MARK: - Variables
	@Environment(\.colorScheme) var colorScheme
	@Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
	@Environment(\.injected) private var injected: DIContainer
	@State private(set) var email: String
	@State private(set) var password: String
	@State private(set) var rePassword: String
	@State private(set) var emailStyle: TextInputStyle
	@State private(set) var passwordStyle: TextInputStyle
	@State private(set) var rePasswordStyle: TextInputStyle
	@State private(set) var focusd: Bool = false
	
	init(email: String = "",
		 password: String = "",
		 rePassword: String = "",
		 emailStyle: TextInputStyle = .default,
		 passwordStyle: TextInputStyle = .default,
		 rePasswordStyle: TextInputStyle = .default) {
		self._email = .init(initialValue: email)
		self._password = .init(initialValue: password)
		self._rePassword = .init(initialValue: rePassword)
		self._emailStyle = .init(initialValue: emailStyle)
		self._passwordStyle = .init(initialValue: rePasswordStyle)
		self._rePasswordStyle = .init(initialValue: rePasswordStyle)
	}
	// MARK: - Body
	var body: some View {
		NavigationView {
			content
				.onReceive(inspection.notice) { inspection.visit(self, $0) }
		}
		.navigationBarBackButtonHidden(true)
		.navigationBarItems(leading: btnBack)
		.frame(maxWidth: .infinity, maxHeight: .infinity)
		.background(backgroundViewColor)
		.edgesIgnoringSafeArea(.all)
	}
}
// MARK: - Private
private extension FogotPasswordView {
	
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
private extension FogotPasswordView {
	func customBack() {
		self.presentationMode.wrappedValue.dismiss()
	}
	
	var content: AnyView {
		AnyView(loadedView(showView: false))
	}
	func loadedView( showView: Bool) -> some View {
		VStack {
			if showView {
				AnyView(securePasswordView)
			} else {
				AnyView(fogotPasswordView)
			}
		}
	}
}
// MARK: - Loading Content
private extension FogotPasswordView {
	var fogotPasswordView: some View {
		VStack(spacing: Constants.spacing) {
			Spacer()
			Text("ForgotPass.Please enter your email to reset your password".localized)
				.font(AppTheme.shared.fontSet.font(style: .body2))
				.foregroundColor(foregroundBackButton)
				.padding(.all)
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
			Button("ForgotPass.Reset password".localized) {
				
			}
			.padding(.all)
			.background(backgroundButton)
			.foregroundColor(foregroundButton)
			.cornerRadius(Constants.radius)
			Spacer()
			Spacer()
			Spacer()
		}.frame(width: Constants.width)
	}
	
	var securePasswordView: some View {
		VStack(spacing: Constants.spacing) {
			Spacer()
			Text("ForgotPass.TitleChangePassword".localized)
				.font(AppTheme.shared.fontSet.font(style: .body2))
				.foregroundColor(foregroundBackButton)
				.padding(.all)
			SecureTextField(secureText: $password,
							inputStyle: $passwordStyle,
							inputIcon: AppTheme.shared.imageSet.lockIcon,
							placeHolder: "General.Password".localized,
							keyboardType: .default )
			SecureTextField(secureText: $rePassword,
							inputStyle: $rePasswordStyle,
							inputIcon: AppTheme.shared.imageSet.lockIcon,
							placeHolder: "General.ConfirmPassword".localized,
							keyboardType: .default )
			Button("ForgotPass.Resetpassword".localized) {
				
			}
			.padding(.all)
			.background(backgroundButton)
			.foregroundColor(foregroundButton)
			.cornerRadius(Constants.radius)
			Spacer()
			Spacer()
			Spacer()
		}.frame(width: Constants.width)
	}
	var btnBack : some View {
		Button(action: customBack) {
			HStack {
				AppTheme.shared.imageSet.backIcon
					.aspectRatio(contentMode: .fit)
					.foregroundColor(foregroundBackButton)
				Spacer()
				Text("ForgotPass.Forgot password".localized)
					.padding(.all)
					.font(AppTheme.shared.fontSet.font(style: .body2))
			}
			.foregroundColor(foregroundBackButton)
		}
	}
}
// MARK: - Interactor
private extension FogotPasswordView {
}
// MARK: - Preview
struct FogotPasswordView_Previews: PreviewProvider {
	static var previews: some View {
		FogotPasswordView(email: "", password: "", rePassword: "", emailStyle: .normal, passwordStyle: .normal, rePasswordStyle: .normal)
	}
}
