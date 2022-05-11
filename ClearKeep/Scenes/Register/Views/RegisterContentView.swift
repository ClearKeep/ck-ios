//
//  RegisterContentView.swift
//  ClearKeep
//
//  Created by MinhDev on 04/03/2022.
//

import SwiftUI
import Common
import CommonUI

private enum Constants {
	static let buttonSize = CGSize(width: 120.0, height: 40.0)
	static let spacing = 20.0
	static let padding = UIEdgeInsets(top: 24.0, left: 16.0, bottom: 24.0, right: 16.0)
	static let paddingtop = 60.0
}

struct RegisterContentView: View {
	// MARK: - Variables
	@Environment(\.injected) private var injected: DIContainer
	@Environment(\.colorScheme) var colorScheme
	@Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
	@Binding var loadable: Loadable<Bool>
	@Binding var customServer: CustomServer
	@State private var email: String = ""
	@State private var emailStyle: TextInputStyle = .default
	@State private var displayName: String = ""
	@State private var displayNameStyle: TextInputStyle = .default
	@State private var password: String = ""
	@State private var passwordStyle: TextInputStyle = .default
	@State private var confirmPassword: String = ""
	@State private var confirmPasswordStyle: TextInputStyle = .default
	
	// MARK: - Body
	var body: some View {
		VStack(alignment: .center, spacing: Constants.spacing) {
			Text("Register.Title".localized)
				.font(AppTheme.shared.fontSet.font(style: .input2))
			CommonTextField(text: $email,
							inputStyle: $emailStyle,
							inputIcon: AppTheme.shared.imageSet.mailIcon,
							placeHolder: "General.Email".localized,
							keyboardType: .default,
							onEditingChanged: { isEditing in
				emailStyle = isEditing ? .highlighted : .normal
			})
			CommonTextField(text: $displayName,
							inputStyle: $displayNameStyle,
							inputIcon: AppTheme.shared.imageSet.userCheckIcon,
							placeHolder: "General.DisplayName".localized,
							keyboardType: .default,
							onEditingChanged: { isEditing in
				displayNameStyle = isEditing ? .highlighted : .normal
			})
			SecureTextField(secureText: $password,
							inputStyle: $passwordStyle,
							inputIcon: AppTheme.shared.imageSet.lockIcon,
							placeHolder: "General.Password".localized,
							keyboardType: .default,
							onEditingChanged: { isEditing in
				passwordStyle = isEditing ? .highlighted : .normal
			})
			SecureTextField(secureText: $confirmPassword,
							inputStyle: $confirmPasswordStyle,
							inputIcon: AppTheme.shared.imageSet.lockIcon,
							placeHolder: "General.ConfirmPassword".localized,
							keyboardType: .default,
							onEditingChanged: { isEditing in
				confirmPasswordStyle = isEditing ? .highlighted : .normal
			})
			HStack {
				Button(action: customBack) {
					Text("Register.SignInInstead".localized)
						.padding(.all)
						.font(AppTheme.shared.fontSet.font(style: .body4))
						.foregroundColor(AppTheme.shared.colorSet.primaryDefault)
				}
				Spacer()
				RoundedGradientButton("Register.SignUp".localized,
									  disabled: .constant(email.isEmpty || displayName.isEmpty || password.isEmpty || confirmPassword.isEmpty),
									  action: doRegister)
				.frame(width: Constants.buttonSize.width)
			}
		}
		.padding(.vertical, Constants.padding.top)
		.padding(.horizontal, Constants.padding.left)
		.applyCardViewStyle(backgroundColor: backgroundColor)
	}
}

// MARK: - Private variables
private extension RegisterContentView {
	var backgroundColor: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.offWhite : AppTheme.shared.colorSet.grey6
	}
}

// MARK: - Interactor
private extension RegisterContentView {
	func doRegister() {
		loadable = .isLoading(last: nil, cancelBag: CancelBag())
		Task {
			loadable = await injected.interactors.registerInteractor.register(displayName: displayName, email: email, password: password, customServer: customServer)
		}
	}
	
	func customBack() {
		self.presentationMode.wrappedValue.dismiss()
	}
}

// MARK: - Preview
#if DEBUG
struct RegisterContentView_Previews: PreviewProvider {
	static var previews: some View {
		RegisterContentView(loadable: .constant(.notRequested), customServer: .constant(CustomServer()))
	}
}
#endif
