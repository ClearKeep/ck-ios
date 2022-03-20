//
//  NewPasswordView.swift
//  ClearKeep
//
//  Created by MinhDev on 08/03/2022.
//

import SwiftUI
import CommonUI
import Common
import CNIOBoringSSL

private enum Constants {
	static let radius = 40.0
	static let spacing = 20.0
	static let padding = 10.0
	static let paddingtop = 100.0
}

struct NewPasswordView: View {
	// MARK: - Constants
	private let inspection = ViewInspector<Self>()

	// MARK: - Variables
	@Environment(\.colorScheme) var colorScheme
	@Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
	@Environment(\.injected) private var injected: DIContainer
	@State private(set) var password: String
	@State private(set) var rePassword: String
	@State private(set) var passwordStyle: TextInputStyle
	@State private(set) var rePasswordStyle: TextInputStyle

	init(password: String = "",
		 rePassword: String = "",
		 passwordStyle: TextInputStyle = .default,
		 rePasswordStyle: TextInputStyle = .default) {
		self._password = .init(initialValue: password)
		self._rePassword = .init(initialValue: rePassword)
		self._passwordStyle = .init(initialValue: rePasswordStyle)
		self._rePasswordStyle = .init(initialValue: rePasswordStyle)
	}
	var body: some View {
		content
			.onReceive(inspection.notice) { inspection.visit(self, $0) }
			.background(backgroundViewColor)
			.edgesIgnoringSafeArea(.all)
			.navigationBarBackButtonHidden(true)
			.navigationBarItems(leading: buttonBack)
	}
}
// MARK: - Private
private extension NewPasswordView {

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
private extension NewPasswordView {
	func customBack() {
		self.presentationMode.wrappedValue.dismiss()
	}

	var content: AnyView {
		AnyView(newPasswordView)
	}
}
// MARK: - Loading Content
private extension NewPasswordView {
	var newPasswordView: some View {
		VStack(spacing: Constants.spacing) {
			Text("ForgotPass.TitleChangePassword".localized)
				.font(AppTheme.shared.fontSet.font(style: .body2))
				.foregroundColor(foregroundBackButton)
				.frame(maxWidth: .infinity, alignment: .leading)
				.padding(.top, Constants.paddingtop)
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
			buttonSave
			Spacer()
		}
		.frame(maxWidth: .infinity, alignment: .center)
		.padding(.all, Constants.padding)
	}
	var buttonBack: some View {
		Button(action: customBack) {
			HStack {
				AppTheme.shared.imageSet.backIcon
					.aspectRatio(contentMode: .fit)
					.foregroundColor(foregroundBackButton)
				Spacer()
				Text("ForgotPass.NewPassword".localized)
					.padding(.all)
					.font(AppTheme.shared.fontSet.font(style: .body2))
			}
			.foregroundColor(foregroundBackButton)
		}
	}
	var buttonSave: some View {
		Button("ForgotPass.Save".localized) {

		}
		.frame(maxWidth: .infinity, alignment: .center)
		.padding(.all, Constants.padding)
		.background(backgroundButton)
		.foregroundColor(foregroundButton)
		.cornerRadius(Constants.radius)
	}
}
// MARK: - Interactor
private extension NewPasswordView {
}
// MARK: - Preview
#if DEBUG
struct NewPasswordView_Previews: PreviewProvider {
	static var previews: some View {
		NewPasswordView()
	}
}
#endif
