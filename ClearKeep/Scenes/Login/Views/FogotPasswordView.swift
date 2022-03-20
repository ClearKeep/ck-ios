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
	static let radius = 40.0
	static let spacing = 20.0
	static let padding = 10.0
	static let paddingtop = 100.0
}

struct FogotPasswordView: View {
	// MARK: - Constants
	private let inspection = ViewInspector<Self>()
	
	// MARK: - Variables
	@Environment(\.colorScheme) var colorScheme
	@Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
	@Environment(\.injected) private var injected: DIContainer
	@State private(set) var email: String
	@State private(set) var emailStyle: TextInputStyle
	@State private(set) var showingNewPass: Bool = false
	init(email: String = "",
		 emailStyle: TextInputStyle = .default) {
		self._email = .init(initialValue: email)
		self._emailStyle = .init(initialValue: emailStyle)
	}
	// MARK: - Body
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
		AnyView(fogotPasswordView)
	}
}
// MARK: - Loading Content
private extension FogotPasswordView {
	var fogotPasswordView: some View {
		VStack(spacing: Constants.spacing) {
			Text("ForgotPass.Please enter your email to reset your password".localized)
				.font(AppTheme.shared.fontSet.font(style: .body2))
				.foregroundColor(foregroundBackButton)
				.frame(maxWidth: .infinity, alignment: .leading)
				.padding(.top, Constants.paddingtop)
			CommonTextField(text: $email,
							inputStyle: $emailStyle,
							inputIcon: AppTheme.shared.imageSet.mailIcon,
							placeHolder: "General.Email".localized,
							keyboardType: .default,
							onEditingChanged: { isEditing in
				if isEditing {
					emailStyle = .default
				} else {
					emailStyle = .normal
				}
			})
			buttonResetPassword
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
				Text("ForgotPass.Forgotpassword".localized)
					.padding(.all)
					.font(AppTheme.shared.fontSet.font(style: .body2))
			}
			.foregroundColor(foregroundBackButton)
		}
	}
	var buttonResetPassword: some View {
		NavigationLink(
			destination: NewPasswordView(password: "", rePassword: "", passwordStyle: .default, rePasswordStyle: .default),
			isActive: $showingNewPass,
			label: {
				Button("ForgotPass.Resetpassword".localized) {
					self.showingNewPass = true
				}
				.frame(maxWidth: .infinity, alignment: .center)
				.padding(.all, Constants.padding)
				.background(backgroundButton)
				.foregroundColor(foregroundButton)
				.cornerRadius(Constants.radius)
			})
	}
}
// MARK: - Interactor
private extension FogotPasswordView {
}
// MARK: - Preview
#if DEBUG
struct FogotPasswordView_Previews: PreviewProvider {
	static var previews: some View {
		FogotPasswordView(email: "", emailStyle: .default)
	}
}
#endif
