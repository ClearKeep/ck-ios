//
//  RegisterContentView.swift
//  ClearKeep
//
//  Created by MinhDev on 04/03/2022.
//

import SwiftUI
import Common
import CommonUI
import Foundation

private enum Constants {
	static let buttonSize = CGSize(width: 120.0, height: 40.0)
	static let spacing = 20.0
	static let padding = UIEdgeInsets(top: 24.0, left: 16.0, bottom: 24.0, right: 16.0)
	static let paddingtop = 60.0
	static let spacingForm = 5.0
	static let opacity = 0.4
}

enum CheckoutFocusable: Hashable {
	case email
	case displayName
	case newpass
	case confirm
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
	@State private var emailInvalid: Bool = false
	@State private var passwordInvalid: Bool = false
	@State private var confirmPasswordInvvalid: Bool = false
	@State private var checkInvalid: Bool = false
	@FocusState private var checkoutInFocus: CheckoutFocusable?
	@State private var isShowAlert: Bool = false
	// MARK: - Body
	var body: some View {
		ZStack {
			VStack(alignment: .leading, spacing: Constants.spacing) {
				Text("Register.Title".localized)
					.font(AppTheme.shared.fontSet.font(style: .input2))
				VStack(alignment: .leading, spacing: Constants.spacingForm) {
					Text("General.Email".localized)
						.font(AppTheme.shared.fontSet.font(style: .input2))
					CommonTextField(text: $email,
									inputStyle: $emailStyle,
									inputIcon: AppTheme.shared.imageSet.mailIcon,
									placeHolder: "General.Email".localized,
									keyboardType: .default,
									onEditingChanged: { isEditing in
						emailStyle = isEditing ? .highlighted : .normal
					},
									submitLabel: .continue,
									onSubmit: { checkoutInFocus = .displayName })
						.focused($checkoutInFocus, equals: .email)
				}
				VStack(alignment: .leading, spacing: Constants.spacingForm) {
					Text("General.DisplayName".localized)
						.font(AppTheme.shared.fontSet.font(style: .input2))
					CommonTextField(text: $displayName,
									inputStyle: $displayNameStyle,
									inputIcon: AppTheme.shared.imageSet.userCheckIcon,
									placeHolder: "General.DisplayName".localized,
									keyboardType: .default,
									onEditingChanged: { isEditing in
						displayNameStyle = isEditing ? .highlighted : .normal
					},
									submitLabel: .continue,
									onSubmit: { checkoutInFocus = .newpass })
						.onReceive(displayName.publisher.collect()) {
							self.displayName = String($0.prefix(30))
						}
						.focused($checkoutInFocus, equals: .displayName)
				}
				VStack(alignment: .leading, spacing: Constants.spacingForm) {
					HStack {
						Text("General.Password".localized)
							.font(AppTheme.shared.fontSet.font(style: .input2))
						Button(action: suggestionsValid ) {
							Image(systemName: "info.circle.fill")
								.resizable()
								.frame(width: 12, height: 12)
								.foregroundColor(.black)
						}
					}
					
					SecureTextField(secureText: $password,
									inputStyle: $passwordStyle,
									inputIcon: AppTheme.shared.imageSet.lockIcon,
									placeHolder: "General.Password".localized,
									keyboardType: .default,
									onEditingChanged: { isEditing in
						passwordStyle = isEditing ? .highlighted : .normal
					},
									submitLabel: .continue,
									onSubmit: { checkoutInFocus = .confirm })
						.onSubmit({ self.checkoutInFocus = .confirm })
						.focused($checkoutInFocus, equals: .newpass)
				}
				VStack(alignment: .leading, spacing: Constants.spacingForm) {
					Text("General.ConfirmPassword".localized)
						.font(AppTheme.shared.fontSet.font(style: .input2))
					SecureTextField(secureText: $confirmPassword,
									inputStyle: $confirmPasswordStyle,
									inputIcon: AppTheme.shared.imageSet.lockIcon,
									placeHolder: "General.ConfirmPassword".localized,
									keyboardType: .default,
									onEditingChanged: { isEditing in
						confirmPasswordStyle = isEditing ? .highlighted : .normal
					},
									submitLabel: .done,
									onSubmit: { self.checkoutInFocus = nil })
						.focused($checkoutInFocus, equals: .confirm)
				}
				HStack {
					Button(action: customBack) {
						Text("Register.SignInInstead".localized)
							.padding(.all)
							.font(AppTheme.shared.fontSet.font(style: .body4))
							.foregroundColor(AppTheme.shared.colorSet.primaryDefault)
					}
					Spacer()
					RoundedGradientButton("Register.SignUp".localized,
										  disabled: .constant(email.isEmpty || displayCheck(displayName: displayName) || password.isEmpty || confirmPassword.isEmpty),
										  action: doRegister)
						.frame(width: Constants.buttonSize.width)
				}
			}
			if $isShowAlert.wrappedValue {
				ZStack {
					Color.white
					VStack {
						Text("General.Password.Rules".localized)
							.font(AppTheme.shared.fontSet.font(style: .placeholder2))
							.frame(alignment: .leading)
						Spacer()
						Button(action: {
							self.isShowAlert = false
						}, label: {
							Text("Close")
						})
					}.padding()
				}
				.animation(.easeIn(duration: 1))
				.frame(width: 300, height: 200)
				.cornerRadius(20)
				.shadow(color: AppTheme.shared.colorSet.black.opacity(Constants.opacity), radius: 20)
				.zIndex(2)
			}
		}
		.onChange(of: checkoutInFocus) { checkoutInFocus = $0 }
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
		invalid()
		if checkInvalid {
			loadable = .isLoading(last: nil, cancelBag: CancelBag())
			Task {
				loadable = await injected.interactors.registerInteractor.register(displayName: displayName.trimmingCharacters(in: .whitespaces), email: email, password: password, customServer: customServer)
			}
		}
	}
	
	func customBack() {
		self.presentationMode.wrappedValue.dismiss()
	}
	
	func invalid() {
		emailInvalid = injected.interactors.registerInteractor.emailValid(email: email)
		emailStyle = emailInvalid ? .normal : .error(message: "General.Email.Valid".localized)
		
		let lengthPassword = injected.interactors.registerInteractor.lengthPassword(password)
		
		passwordInvalid = injected.interactors.registerInteractor.passwordValid(password: password)
		passwordStyle = passwordInvalid ? .normal : .error(message: lengthPassword ?  "General.Password.Invalid".localized : "General.Password.Valid".localized )
		
		confirmPasswordInvvalid = injected.interactors.registerInteractor.confirmPasswordValid(password: password, confirmPassword: confirmPassword)
		confirmPasswordStyle = confirmPasswordInvvalid ? .normal : .error(message: "General.ConfirmPassword.Valid".localized)
		
		checkInvalid = injected.interactors.registerInteractor.checkValid(emailValid: emailInvalid, passwordValdid: passwordInvalid, confirmPasswordValid: confirmPasswordInvvalid)
	}
	
	func displayCheck(displayName: String) -> Bool {
		return displayName.filter { $0 != " " }.isEmpty
	}
	
	func suggestionsValid() {
		isShowAlert = true
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
