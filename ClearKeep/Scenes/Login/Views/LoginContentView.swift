//
//  LoginView.swift
//  ClearKeep
//
//  Created by đông on 02/03/2022.
//
import SwiftUI
import Combine
import Common
import CommonUI
import Model
import ChatSecure
import Networking

private enum Constants {
	static let inputViewSpacing = 24.0
	static let extraButtonViewHeight = 22.0
	static let extraButtonViewPaddingTop = 16.0
	static let separateLineHeight = 1.0
	static let separateLinePaddingTop = 32.0
	static let socialViewPaddingTop = 24.0
	static let socialViewSpacing = 40.0
	static let signUpViewPaddingTop = 45.0
	static let appVersionPaddingTop = 30.0
}

struct LoginContentView: View {
	// MARK: - Variables
	@Environment(\.injected) private var injected: DIContainer
	@Environment(\.colorScheme) var colorScheme
	@Environment(\.joinServerClosure) private var joinServerClosure: JoinServerClosure
	@Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
	@Binding var customServer: CustomServer
	var dismiss: (() -> Void)
	@State private var email: String = ""
	@State private var password: String = ""
	@State private var emailStyle: TextInputStyle = .default
	@State private var passwordStyle: TextInputStyle = .default
	@State private var appVersion: String = "General.Version".localized
	@State private var editingEmail = false
	@State private var editingPassword = false
	@State private var isAdvanceServer: Bool = false
	@State private var isForgotPassword: Bool = false
	@State private var isRegister: Bool = false
	@State private(set) var navigateToHome: Bool = false
	@State private(set) var isShowAlertLogin: Bool = false
	@State private var activeAlert: LoginViewPopUp = .invalidEmail
	@State private var isShowLoading: Bool = false
	@State private var normalLogin: INormalLoginModel?
	@State private var navigationTwoFace: Int? = 0
	@State private var userName: String = ""
	@State private var socialStyle: SocialCommonStyle = .setSecurity
	@State private var resetPincodeToken: String = ""
	// MARK: - Init
	
	// MARK: - Body
	var body: some View {
		VStack {
			NavigationLink(destination: TwoFactorView(otpHash: normalLogin?.otpHash ?? "",
													  userId: normalLogin?.sub ?? "",
													  domain: normalLogin?.workspaceDomain ?? "",
													  password: password,
													  twoFactorType: .login),
						   tag: 1,
						   selection: $navigationTwoFace,
						   label: {
				EmptyView()
			})
			
			NavigationLink(destination: SocialView(userName: userName, resetToken: resetPincodeToken, pinCode: nil, socialStyle: socialStyle, customServer: $customServer, dismiss: self.dismiss),
						   tag: 2,
						   selection: $navigationTwoFace,
						   label: {
				EmptyView()
			})
			inputView
			extraButtonView
				.frame(height: Constants.extraButtonViewHeight)
				.padding(.top, Constants.extraButtonViewPaddingTop)
			Rectangle()
				.frame(height: Constants.separateLineHeight)
				.foregroundColor(AppTheme.shared.colorSet.offWhite)
				.padding(.top, Constants.separateLinePaddingTop)
			socialView
				.padding(.top, Constants.socialViewPaddingTop)
			signUpView
				.padding(.top, Constants.signUpViewPaddingTop)
			
			Text(appVersion)
				.font(AppTheme.shared.fontSet.font(style: .placeholder3))
				.foregroundColor(AppTheme.shared.colorSet.offWhite)
				.onAppear(perform: {
					getAppVersion()
				})
				.padding(.top, Constants.appVersionPaddingTop)
		}
		.alert(isPresented: $isShowAlertLogin) {
			switch activeAlert {
			case .invalid, .error, .invalidEmail, .emailBlank, .passwordBlank:
				return Alert(title: Text(activeAlert.title),
							 message: Text(activeAlert.message),
							 dismissButton: .default(Text(activeAlert.primaryButtonTitle)))
			case .forgotPassword:
				return Alert(title: Text(activeAlert.title),
							 message: Text(activeAlert.message),
					primaryButton: .default(Text("ForgotPassword.Cancel".localized)),
					secondaryButton: .default(Text("ForgotPassword.OK" .localized), action: {
				  self.isForgotPassword = true
			  }))
			}
		}
		.progressHUD(isShowLoading)
	}
}

// MARK: - Private
private extension LoginContentView {
}

// MARK: - Loading Content
private extension LoginContentView {
	var inputView: some View {
		VStack(spacing: Constants.inputViewSpacing) {
			CommonTextField(text: $email,
							inputStyle: $emailStyle,
							inputIcon: AppTheme.shared.imageSet.mailIcon,
							placeHolder: "General.Email".localized,
							keyboardType: .default,
							onEditingChanged: { isEditing in
				emailStyle = isEditing ? .highlighted : .normal
			})
			SecureTextField(secureText: $password,
							inputStyle: $passwordStyle,
							inputIcon: AppTheme.shared.imageSet.lockIcon,
							placeHolder: "General.Password".localized,
							keyboardType: .default,
							onEditingChanged: { isEditing in
				passwordStyle = isEditing ? .highlighted : .normal
			})
			RoundedButton("Login.SignIn".localized, action: checkValid)
		}
	}
	
	var extraButtonView: some View {
		HStack {
			if navigateToHome == false {
				NavigationLink(destination: AdvancedSeverView(),
							   isActive: $isAdvanceServer,
							   label: {
					LinkButton("Login.AdvancedServerSettings".localized, alignment: .leading, action: advancedServer)
						.foregroundColor(colorScheme == .light ? AppTheme.shared.colorSet.offWhite : AppTheme.shared.colorSet.primaryDefault)
				})
			}
			Spacer()
			NavigationLink(destination: FogotPasswordView(customServer: $customServer),
						   isActive: $isForgotPassword,
						   label: {
				LinkButton("Login.ForgotPassword".localized, alignment: .trailing, action: forgotPassword)
					.foregroundColor(colorScheme == .light ? AppTheme.shared.colorSet.offWhite : AppTheme.shared.colorSet.primaryDefault)
			})
		}
	}
	
	var socialView: some View {
		VStack(alignment: .center, spacing: Constants.socialViewPaddingTop) {
			Text("Login.SignInWith".localized)
				.font(AppTheme.shared.fontSet.font(style: .body3))
				.foregroundColor(AppTheme.shared.colorSet.offWhite)
			HStack(spacing: Constants.socialViewSpacing) {
				ImageButton(AppTheme.shared.imageSet.googleIcon) { doSocialLogin(type: .google) }
				ImageButton(AppTheme.shared.imageSet.officeIcon) { doSocialLogin(type: .office) }
				ImageButton(AppTheme.shared.imageSet.facebookIcon) { doSocialLogin(type: .facebook) }
				ImageButton(AppTheme.shared.imageSet.appleIcon) { doSocialLogin(type: .apple) }
			}
		}
	}
	
	var signUpView: some View {
		VStack(spacing: Constants.extraButtonViewPaddingTop) {
			Text("Login.SignUp.Suggest".localized)
				.font(AppTheme.shared.fontSet.font(style: .body3))
				.foregroundColor(AppTheme.shared.colorSet.offWhite)
			
			NavigationLink(destination: RegisterView(customServer: $customServer),
						   isActive: $isRegister,
						   label: {
				RoundedBorderButton("Login.SignUp".localized, action: register)
			})
		}
	}
}

// MARK: - Private func
private extension LoginContentView {
}

// MARK: - Interactors
private extension LoginContentView {
	func getAppVersion() {
		appVersion = injected.interactors.loginInteractor.getAppVersion()
	}
	
	func checkValid() {
		email.isEmpty ? {
			self.activeAlert = .emailBlank
			self.isShowAlertLogin = true
		}() : passwordValid()
	}
	
	func passwordValid() {
		password.isEmpty ? {
			self.activeAlert = .passwordBlank
			self.isShowAlertLogin = true
		}() : emailValid()
	}

	func emailValid() {
		let emailValidate = injected.interactors.loginInteractor.emailValid(email: email.trimmingCharacters(in: .whitespacesAndNewlines))
		emailValidate ? passvalid() : ({
			self.activeAlert = .invalidEmail
			self.isShowAlertLogin = true
		})()
	
	}

	func passvalid() {
		let passValidate = injected.interactors.loginInteractor.passwordValid(password: password)
		passValidate ? doLogin() : ({
			self.activeAlert = .invalidEmail
			self.isShowAlertLogin = true
		})()
	}

	func doLogin() {
		self.isShowLoading = true
		Task {
			let loadable = await injected.interactors.loginInteractor.signIn(email: email.trimmingCharacters(in: .whitespacesAndNewlines), password: password, customServer: customServer)
			self.isShowLoading = false
			switch loadable {
			case .loaded(let data):
				guard let normalLogin = data.normalLogin else {
					return
				}
				let accessToken = normalLogin.accessToken ?? ""
				if accessToken.isEmpty {
					navigationTwoFace = 1
					return
				}
				
				if navigateToHome {
					self.presentationMode.wrappedValue.dismiss()
					self.joinServerClosure?(customServer.customServerURL)
				}
				if let token = UserDefaults.standard.data(forKey: "keySaveTokenPushNotification") {
					injected.interactors.homeInteractor.registerToken(token)
				}
				self.dismiss()
			case .failed(let error):
				self.isShowAlertLogin = true
				self.activeAlert = .error(err: LoginViewError(error))
			default:
				break
			}
		}
	}
	
	func doSocialLogin(type: SocialType) {
		self.isShowLoading = true
		Task {
			let loadable = await injected.interactors.loginInteractor.signInSocial(type, customServer: customServer)
			self.isShowLoading = false
			switch loadable {
			case .loaded(let data):
				guard let socialLogin = data.socialLogin,
					  let userName = socialLogin.userName else {
					return
				}
					switch socialLogin.requireAction {
					case "register_pincode":
						self.socialStyle = .setSecurity
						self.resetPincodeToken = ""
						self.userName = userName
						self.navigationTwoFace = 2
					case "verify_pincode":
						self.socialStyle = .verifySecurity
						self.resetPincodeToken = socialLogin.resetPincodeToken ?? ""
						if type == .apple {
							self.userName = socialLogin.userId ?? userName
						} else {
							self.userName = userName
						}
						self.navigationTwoFace = 2
					default:
						break
					}
				
			case .failed(let error):
				if let errorResponse = error as? IServerError,
				   errorResponse.message == nil && errorResponse.name == nil && errorResponse.status == nil {
					return
				}
				self.isShowAlertLogin = true
				self.activeAlert = .error(err: LoginViewError(error))
			default:
				break
			}
		}
	}
	
	func advancedServer() {
		isAdvanceServer = true
	}
	
	func forgotPassword() {
		self.activeAlert = .forgotPassword
		self.isShowAlertLogin = true
	}
	
	func register() {
		isRegister = true
	}
}

#if DEBUG
struct LoginContentView_Previews: PreviewProvider {
	static var previews: some View {
		LoginContentView(customServer: .constant(CustomServer()), dismiss: {})
	}
}
#endif
