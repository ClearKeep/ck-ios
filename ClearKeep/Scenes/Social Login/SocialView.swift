//
//  SocialView.swift
//  ClearKeep
//
//  Created by đông on 18/03/2022.
//

import SwiftUI
import Combine
import Common
import CommonUI
import Model
import ChatSecure

private enum Constants {
	static let inputSpacing = 10.0
	static let inputPaddingTop = 32.0
	static let descriptionHeight = 24.0
	static let submitPaddingTop = 104.0
	static let paddingHorizontal = 16.0
}

struct SocialView: View {
	// MARK: - Variables
	@Environment(\.presentationMode) var presentationMode
	@Environment(\.injected) private var injected: DIContainer
	@Environment(\.colorScheme) var colorScheme
	@Binding var customServer: CustomServer
	@State private(set) var security: String = ""
	@State private(set) var securityStyle: TextInputStyle = .default
	@State private(set) var isNext: Bool = false
	@State private var showAlert: Bool = false
	@State private var setSecurityPhase: Bool = false
	@State private var isLoading: Bool = false
	@State private var error: SocialViewError?
	@State private var isShowAlertForgotPassPhrase = false
	
	var pinCode: String?
	let userName: String
	var resetToken: String = ""
	let socialStyle: SocialCommonStyle
	let inspection = ViewInspector<Self>()
	
	// MARK: - Init
	init(userName: String, socialStyle: SocialCommonStyle, customServer: Binding<CustomServer>) {
		self.userName = userName
		self.socialStyle = socialStyle
		self._customServer = customServer
	}
	
	init(userName: String, resetToken: String, pinCode: String?, socialStyle: SocialCommonStyle, customServer: Binding<CustomServer>) {
		self.userName = userName
		self.socialStyle = socialStyle
		self._customServer = customServer
		self.resetToken = resetToken
		self.pinCode = pinCode
	}
	
	// MARK: - Body
	var body: some View {
		notRequestedView
			.padding(.horizontal, Constants.paddingHorizontal)
			.onReceive(inspection.notice) { inspection.visit(self, $0) }
			.applyNavigationBarPlainStyle(title: socialStyle.buttonBack,
										  titleColor: titleColor,
										  leftBarItems: {
				BackButton(customBack)
			},
										  rightBarItems: {
				Spacer()
			})
			.grandientBackground()
			.hideKeyboardOnTapped()
			.keyboardAdaptive()
			.edgesIgnoringSafeArea(.all)
			.progressHUD(self.isLoading)
			.alert(isPresented: $showAlert) {
				if !self.isShowAlertForgotPassPhrase {
					return Alert(title: Text(error?.title ?? ""),
								 message: Text("Social.Warning.Security.PhraseIsIncorrect".localized),
								 dismissButton: .default(Text(error?.primaryButtonTitle ?? "")))
				}
				
				return Alert(title: Text("Social.Warning".localized),
							 message: Text("Social.Warning.Description".localized),
							 primaryButton: .default(Text("Social.Warning.Cancel".localized)),
							 secondaryButton: .default(Text("Reset"), action: {
					setSecurityPhase = true
				}))
			}
		
		NavigationLink(destination: SocialView(userName: userName, resetToken: resetToken, pinCode: nil, socialStyle: .forgotPassface, customServer: $customServer), isActive: $setSecurityPhase, label: {})
		
		NavigationLink(
			destination: socialStyle.nextView(userName: userName, token: resetToken, pinCode: self.security, customServer: $customServer),
			isActive: $isNext,
			label: {
			})
	}
}

// MARK: - Loading Content
private extension SocialView {
	var notRequestedView: some View {
		ScrollView(showsIndicators: false) {
			VStack {
				Text(socialStyle.title)
					.font(AppTheme.shared.fontSet.font(style: .input2))
					.foregroundColor(titleColor)
					.frame(maxWidth: .infinity, alignment: .leading)
				VStack(alignment: .center, spacing: Constants.inputSpacing) {
					SecureTextField(secureText: $security,
									inputStyle: $securityStyle,
									inputIcon: AppTheme.shared.imageSet.lockIcon,
									placeHolder: socialStyle.textInput,
									keyboardType: .numberPad,
									onEditingChanged: { isEditing in
						securityStyle = isEditing ? .highlighted : .normal
					}, textChange: { text in
						checkNotSameDataVerify(text: text)
					})
					
					if socialStyle == .setSecurity || socialStyle == .forgotPassface {
						Text(socialStyle.textInputDescription)
							.font(AppTheme.shared.fontSet.font(style: .body3))
							.foregroundColor(titleColor)
							.multilineTextAlignment(.center)
							.frame(maxWidth: .infinity)
					}
				}
				.padding(.top, Constants.inputPaddingTop)
				
				if socialStyle == .verifySecurity {
					Button(action: showAlertForgotPassPhrase) {
						Text("Social.ForgotPassPhasre".localized)
							.font(AppTheme.shared.fontSet.font(style: .input2))
							.foregroundColor(AppTheme.shared.colorSet.offWhite)
					}.padding(.top, Constants.submitPaddingTop)
				}
				
				RoundedButton(socialStyle.buttonNext, disabled: .constant(checkDisableButton()), action: submitAction)
					.padding(.top, socialStyle == .setSecurity ? Constants.submitPaddingTop - Constants.descriptionHeight : socialStyle == .verifySecurity ? 12 : Constants.submitPaddingTop)
				Spacer()
			}
		}.frame(maxWidth: .infinity)
		
	}
	
	var loadingView: some View {
		notRequestedView.progressHUD(true)
	}
	
	func loadedView(_ data: IAuthenticationModel) -> AnyView {
		if let normalLogin = data.normalLogin {
			return AnyView(Text(normalLogin.workspaceDomain ?? ""))
		}
		return AnyView(errorView(SocialViewError.unknownError(errorCode: nil)))
	}
	
	func errorView(_ error: SocialViewError) -> some View {
		return notRequestedView
			.alert(isPresented: .constant(true)) {
				Alert(title: Text(error.title),
					  message: Text(error.message),
					  dismissButton: .default(Text(error.primaryButtonTitle)))
			}
	}
}

// MARK: - Support Variables
private extension SocialView {
	var titleColor: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.offWhite : AppTheme.shared.colorSet.grey3
	}
}

// MARK: - Private Func
private extension SocialView {
	func customBack() {
		self.presentationMode.wrappedValue.dismiss()
	}
	
	func showAlertForgotPassPhrase() {
		self.isShowAlertForgotPassPhrase = true
		showAlert = true
	}
}

// MARK: - Interactors
private extension SocialView {
	func submitAction() {
		Task {
			var result:Loadable<IAuthenticationModel>?
			switch socialStyle {
			case .setSecurity, .forgotPassface:
				isNext = true
			case .confirmSecurity:
				self.isLoading = true
				result = await injected.interactors.socialInteractor.registerSocialPin(userName: userName, rawPin: self.convertString(text: security), customServer: customServer)
			case .verifySecurity:
				self.isLoading = true
				result = await injected.interactors.socialInteractor.verifySocialPin(userName: userName, rawPin: self.convertString(text: security), customServer: customServer)
			case .confirmResetSecurity:
				self.isLoading = true
				result = await injected.interactors.socialInteractor.resetSocialPin(userName: userName, rawPin: self.convertString(text: security), token: self.resetToken, customServer: customServer)
			}
			
			self.isLoading = false
			switch result {
			case .loaded(let data):
				if (data.normalLogin) != nil {
					return
				}
				self.isShowAlertForgotPassPhrase = false
				error = SocialViewError.unknownError(errorCode: nil)
				showAlert = true
			case .failed(let error):
				self.isShowAlertForgotPassPhrase = false
		 		self.error = SocialViewError(error)
				showAlert = true
			default:
				return
			}
		}
	}
	
	func checkDisableButton() -> Bool {
		if security.isEmpty {
			return true
		}
		
		if let pincode = self.pinCode,
		   pincode != security {
			return true
		}
		
		let string = self.convertString(text: security)
		if string.components(separatedBy: " ").count < 3 {
			return true
		}
		
		if string.replacingOccurrences(of: " ", with: "").count < 15 {
			return true
		}
		
		return false
	}
	
	func checkNotSameDataVerify(text: String) {
		if text.isEmpty {
			return
		}
		
		guard let pinCode = self.pinCode else {
			return
		}
		
		if pinCode != self.security {
			self.securityStyle = .error(message: "Social.NotSamePinCode".localized)
			return
		}
		
		self.securityStyle = .highlighted
	}
	
	func convertString(text: String) -> String {
		return security.replacingOccurrences(of: "[\\s\n]+", with: " ", options: .regularExpression, range: nil)
	}
}

struct SocialView_Previews: PreviewProvider {
	static var previews: some View {
		SocialView(userName: "", socialStyle: .confirmSecurity, customServer: .constant(CustomServer()))
	}
}
