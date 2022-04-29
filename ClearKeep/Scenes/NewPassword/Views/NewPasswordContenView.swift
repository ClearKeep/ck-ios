//
//  NewPasswordContenView.swift
//  ClearKeep
//
//  Created by MinhDev on 22/03/2022.
//

import SwiftUI
import CommonUI
import Common

private enum Constants {
	static let radius = 40.0
	static let spacing = 40.0
	static let spacingHstack = 23.0
	static let padding = 30.0
	static let paddingTextfield = 24.0
	static let paddingButton = 10.0
	static let paddingText = 10.0
	static let paddingtop = 90.0
	static let paddingLeding = 16.0
}

struct NewPasswordContenView: View {
	// MARK: - Constants
	private let inspection = ViewInspector<Self>()

	// MARK: - Variables
	@Environment(\.colorScheme) var colorScheme
	@Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
	@Environment(\.injected) private var injected: DIContainer
	@State private(set) var password: String = ""
	@State private(set) var rePassword: String = ""
	@State private(set) var passwordStyle: TextInputStyle
	@State private(set) var rePasswordStyle: TextInputStyle
	@State private(set) var isLogin: Bool = false

	// MARK: - Init
	init(passwordStyle: TextInputStyle = .default,
		 rePasswordStyle: TextInputStyle = .default) {
		self._passwordStyle = .init(initialValue: rePasswordStyle)
		self._rePasswordStyle = .init(initialValue: rePasswordStyle)
	}

	// MARK: - Body
	var body: some View {
		VStack(spacing: Constants.spacing) {
			VStack(alignment: .leading, spacing: Constants.padding) {
				Button(action: customBack) {
					HStack(spacing: Constants.spacingHstack) {
						AppTheme.shared.imageSet.backIcon
							.renderingMode(.template)
							.aspectRatio(contentMode: .fit)
							.foregroundColor(foregroundBackButton)
						Text("ForgotPass.NewPassword".localized)
							.font(AppTheme.shared.fontSet.font(style: .body2))
					}
					.foregroundColor(foregroundBackButton)
				}
				.padding(.top, Constants.paddingtop)
				.frame(maxWidth: .infinity, alignment: .leading)
				Text("ForgotPass.TitleChangePassword".localized)
					.font(AppTheme.shared.fontSet.font(style: .input2))
					.foregroundColor(foregroundBackButton)
					.padding(.horizontal, Constants.paddingText)
			}
			VStack(spacing: Constants.paddingTextfield) {
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
				NavigationLink(
					destination: LoginView(),
					isActive: $isLogin,
					label: {
						Button {
							self.isLogin = true
						} label: {
							Text("ForgotPass.Save".localized)
								.font(AppTheme.shared.fontSet.font(style: .body3))
								.foregroundColor(foregroundButton)
						}
						.frame(maxWidth: .infinity, alignment: .center)
						.padding(.all, Constants.paddingButton)
						.background(backgroundButton)
						.cornerRadius(Constants.radius)
					}).disabled(password.isEmpty || rePassword.isEmpty)
			}
			Spacer()
		}
		.frame(maxWidth: .infinity, alignment: .center)
		.padding(.horizontal, Constants.paddingLeding)
		.background(backgroundViewColor)
		.edgesIgnoringSafeArea(.all)
		.navigationBarBackButtonHidden(true)
	}
}

// MARK: - Private
private extension NewPasswordContenView {

	var backgroundButton: Color {
		password.isEmpty || rePassword.isEmpty ? backgroundButtonUnActive : backgroundButtonActive
	}

	var backgroundButtonUnActive: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.offWhite.opacity(0.5) : AppTheme.shared.colorSet.primaryDefault.opacity(0.5)
	}

	var backgroundButtonActive: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.offWhite : AppTheme.shared.colorSet.primaryDefault
	}

	var backgroundViewColor: LinearGradient {
		colorScheme == .light ? backgroundColorGradient : backgroundColorBlack
	}

	var backgroundColorBlack: LinearGradient {
		LinearGradient(gradient: Gradient(colors: AppTheme.shared.colorSet.gradientBlack), startPoint: .leading, endPoint: .trailing)
	}

	var backgroundColorGradient: LinearGradient {
		LinearGradient(gradient: Gradient(colors: AppTheme.shared.colorSet.gradientPrimary), startPoint: .leading, endPoint: .trailing)
	}

	var foregroundButton: Color {
		password.isEmpty || rePassword.isEmpty ? foregroundButtonUnActive : foregroundButtonActive
	}

	var foregroundButtonActive: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.primaryDefault : AppTheme.shared.colorSet.offWhite
	}

	var foregroundButtonUnActive: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.primaryDefault.opacity(0.5) : AppTheme.shared.colorSet.offWhite.opacity(0.5)
	}

	var foregroundBackButton: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.offWhite : AppTheme.shared.colorSet.grey3
	}
}

// MARK: - Private Func
private extension NewPasswordContenView {
	func customBack() {
		self.presentationMode.wrappedValue.dismiss()
	}
}

// MARK: - Preview
#if DEBUG
struct NewPasswordContenView_Previews: PreviewProvider {
	static var previews: some View {
		NewPasswordContenView()
	}
}
#endif
