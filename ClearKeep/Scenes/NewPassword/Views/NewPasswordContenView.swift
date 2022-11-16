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
	static let spacing = 40.0
	static let padding = 30.0
	static let paddingTextfield = 24.0
	static let paddingLeading = 16.0
	static let radiusButton: CGFloat = 40
	static let buttonHeight: CGFloat = 40
	static let spacingVstack = 8.0
	static let opacity = 0.4
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
	@State private(set) var passwordStyle: TextInputStyle = .default
	@State private(set) var rePasswordStyle: TextInputStyle = .default
	@State private(set) var isLogin: Bool = false
	@State private var passwordInvalid: Bool = false
	@State private var confirmPasswordInvvalid: Bool = false
	@State private var checkInvalid: Bool = false
	@State private var isLoading: Bool = false
	@State private var isShowError: Bool = false
	@State private var error: ErrorType?
	let preAccessToken: String
	let email: String
	let domain: String
	@State private var isShowAlert: Bool = false
	// MARK: - Init
	init(preAccessToken: String, email: String, domain: String) {
		self.preAccessToken = preAccessToken
		self.email = email
		self.domain = domain
	}
	
	// MARK: - Body
	var body: some View {
		ZStack {
			VStack(spacing: Constants.spacing) {
				Text("NewPassword.Description".localized)
					.font(AppTheme.shared.fontSet.font(style: .input2))
					.foregroundColor(titleColor)
					.frame(maxWidth: .infinity, alignment: .leading)
				VStack(spacing: Constants.paddingTextfield) {
					VStack(alignment: .leading, spacing: Constants.spacingVstack) {
						HStack {
							Text("NewPassword.New.PlaceHold".localized)
								.foregroundColor(titleColor)
								.font(AppTheme.shared.fontSet.font(style: .input2))
							Button(action: suggestionsValid ) {
								Image(systemName: "info.circle.fill")
									.resizable()
									.frame(width: 12, height: 12)
									.foregroundColor(titleColor)
							}
						}
						SecureTextField(secureText: $password,
										inputStyle: $passwordStyle,
										inputIcon: AppTheme.shared.imageSet.lockIcon,
										placeHolder: "NewPassword.New.PlaceHold".localized,
										keyboardType: .default,
										onEditingChanged: { isEdit in
							passwordStyle = isEdit ? .highlighted : .normal
						})
					}
					VStack(alignment: .leading, spacing: Constants.spacingVstack) {
						Text("General.ConfirmPassword".localized)
							.foregroundColor(titleColor)
							.font(AppTheme.shared.fontSet.font(style: .input2))
						SecureTextField(secureText: $rePassword,
										inputStyle: $rePasswordStyle,
										inputIcon: AppTheme.shared.imageSet.lockIcon,
										placeHolder: "General.ConfirmPassword".localized,
										keyboardType: .default,
										onEditingChanged: { isEdit in
							rePasswordStyle = isEdit ? .highlighted : .normal
						})
					}
					Button(action: {
						self.doResetPassword()
					}, label: {
						Text("General.Save".localized)
							.font(AppTheme.shared.fontSet.font(style: .body3))
							.frame(maxWidth: .infinity, maxHeight: .infinity)
					})
						.disabled(password.isEmpty || rePassword.isEmpty)
						.background(password.isEmpty || rePassword.isEmpty ? backgroundColorUnActive : backgroundColorActive)
						.foregroundColor(password.isEmpty || rePassword.isEmpty ? foregroundColorUnActive : foregroundColorActive)
						.cornerRadius(Constants.radiusButton)
						.frame(height: Constants.buttonHeight)
						.frame(maxWidth: .infinity)
				}
				Spacer()
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
				.offset(y: -80)
			}
		}
		.frame(maxWidth: .infinity, alignment: .center)
		.padding(.horizontal, Constants.paddingLeading)
		.edgesIgnoringSafeArea(.all)
		.progressHUD(isLoading)
		.applyNavigationBarPlainStyle(title: "NewPassword.Title".localized,
									  titleColor: titleColor,
									  leftBarItems: {
			BackButton(customBack)
		},
									  rightBarItems: {
			Spacer()
		})
		.alert(isPresented: self.$isShowAlert) {
			Alert(title: Text(""),
				  message: Text("General.Password.Rules".localized),
				  dismissButton: .default(Text("General.OK".localized)))
		}
		.alert(isPresented: $isShowError) {
			switch error {
			case .fail(let err):
				return Alert(title: Text(err.title),
							 message: Text(err.message),
							 dismissButton: .default(Text(err.primaryButtonTitle)))
			default:
				return 	Alert(title: Text("ForgotPassword.PasswordChangeSuccess".localized), message: Text("ForgotPassword.PleaseLoginAgainNewPassword".localized), dismissButton: .default(Text("ForgotPassword.OK".localized), action: {
					self.presentationMode.wrappedValue.dismiss()
				}))
			}
		}
	}
	
	enum ErrorType {
		case forgotSuccess
		case fail(LoginViewError)
	}
}

// MARK: - Private
private extension NewPasswordContenView {
	var titleColor: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.offWhite : AppTheme.shared.colorSet.grey3
	}
	
	var foregroundColorActive: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.primaryDefault : AppTheme.shared.colorSet.offWhite
	}
	
	var foregroundColorUnActive: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.primaryDefault.opacity(0.5) : AppTheme.shared.colorSet.offWhite.opacity(0.5)
	}
	
	var backgroundColorActive: LinearGradient {
		if colorScheme == .light {
			return LinearGradient(gradient: Gradient(colors: [AppTheme.shared.colorSet.offWhite]), startPoint: .leading, endPoint: .trailing)
		} else {
			return LinearGradient(gradient: Gradient(colors: AppTheme.shared.colorSet.gradientLinear), startPoint: .leading, endPoint: .trailing)
		}
	}
	
	var backgroundColorUnActive: LinearGradient {
		if colorScheme == .light {
			return LinearGradient(gradient: Gradient(colors: [AppTheme.shared.colorSet.offWhite].compactMap({ $0.opacity(0.5) })), startPoint: .leading, endPoint: .trailing)
		} else {
			return LinearGradient(gradient: Gradient(colors: AppTheme.shared.colorSet.gradientLinear.compactMap({ $0.opacity(0.5) })), startPoint: .leading, endPoint: .trailing)
		}
	}
}

// MARK: - Private Func
private extension NewPasswordContenView {
	func customBack() {
		self.presentationMode.wrappedValue.dismiss()
	}
	
	func doResetPassword() {
		invalid()
		if checkInvalid {
			isLoading = true
			Task {
				let data = await injected.interactors.newPasswordInteractor.resetPassword(preAccessToken: preAccessToken, email: email, rawNewPassword: password.trimmingCharacters(in: .whitespacesAndNewlines), domain: domain)
				
				switch data {
				case .success:
					isLoading = false
					self.error = .forgotSuccess
					self.isShowError = true
				case .failure(let error):
					isLoading = false
					self.error = .fail(LoginViewError(error))
					self.isShowError = true
				}
			}
		}
	}
	
	func invalid() {
		let lengthPassword = injected.interactors.newPasswordInteractor.lengthPassword(password.trimmingCharacters(in: .whitespacesAndNewlines))
		
		passwordStyle = passwordInvalid ? .normal : .error(message: "General.Password.Invalid".localized)
		
		passwordInvalid = injected.interactors.newPasswordInteractor.passwordValid(password: password.trimmingCharacters(in: .whitespacesAndNewlines))
		
		passwordStyle = passwordInvalid ? .normal : .error(message: lengthPassword ? "General.Password.Invalid".localized : "General.Password.Valid".localized)
		
		confirmPasswordInvvalid = injected.interactors.newPasswordInteractor.confirmPasswordValid(password: password.trimmingCharacters(in: .whitespacesAndNewlines), confirmPassword: rePassword.trimmingCharacters(in: .whitespacesAndNewlines))
		rePasswordStyle = confirmPasswordInvvalid ? .normal : .error(message: "General.ConfirmPassword.Valid".localized)
		
		checkInvalid = injected.interactors.newPasswordInteractor.checkValid(passwordValdid: passwordInvalid, confirmPasswordValid: confirmPasswordInvvalid)
	}
	
	func suggestionsValid() {
		isShowAlert = true
	}
}

// MARK: - Preview
#if DEBUG
struct NewPasswordContenView_Previews: PreviewProvider {
	static var previews: some View {
		NewPasswordContenView(preAccessToken: "", email: "", domain: "")
	}
}
#endif
