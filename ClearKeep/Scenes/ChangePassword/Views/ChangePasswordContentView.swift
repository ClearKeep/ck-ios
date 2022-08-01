//
//  ChangePasswordContentView.swift
//  ClearKeep
//
//  Created by MinhDev on 22/03/2022.
//

import SwiftUI
import CommonUI
import Common
import LibSignalClient
import Model
import Networking

private enum Constants {
	static let radius = 40.0
	static let spacing = 20.0
	static let padding = 16.0
	static let paddingtop = 50.0
}

struct ChangePasswordContentView: View {
	// MARK: - Constants
	private let inspection = ViewInspector<Self>()
	
	// MARK: - Variables
	@Environment(\.colorScheme) var colorScheme
	@Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
	@Environment(\.injected) private var injected: DIContainer
	@State private(set) var preAccessToken: String = ""
	@State private(set) var domain: String = ""
	@State private(set) var currentPassword: String = ""
	@State private(set) var newPassword: String = ""
	@State private(set) var confirmPassword: String = ""
	@State private(set) var currentStyle: TextInputStyle = .default
	@State private(set) var newStyle: TextInputStyle = .default
	@State private(set) var confirmStyle: TextInputStyle = .default
	@State private(set) var currentInvalid: Bool = false
	@State private var passwordInvalid: Bool = false
	@State private var confirmPasswordInvvalid: Bool = false
	@State private var confirmInvvalid: Bool = false
	@State private var checkInvalid: Bool = false
	@State private var isShowAlert: Bool = false
	@State private var messageAlert: String = ""
	@State private var data: INormalLoginModel?
	// MARK: - Init

	// MARK: - Body
	var body: some View {
		content
			.applyNavigationBarPlainStyle(title: "NewPassword.Title".localized,
										  titleColor: titleColor,
										  backgroundColors: backgroundButtonBack,
										  leftBarItems: {
				BackButtonStandard(customBack)
			},
										  rightBarItems: {
				Spacer()
			})
			.edgesIgnoringSafeArea(.all)
			.grandientBackground()
			.alert(isPresented: self.$isShowAlert) {
				Alert(title: Text("GroupChat.Warning".localized),
					  message: Text(self.messageAlert),
					  dismissButton: .default(Text("GroupChat.Ok".localized)))
			}
	}
}

// MARK: - Private
private extension ChangePasswordContentView {
	
	var backgroundButton: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.offWhite : AppTheme.shared.colorSet.primaryDefault
	}
	
	var foregroundButton: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.primaryDefault : AppTheme.shared.colorSet.offWhite
	}
	
	var foregroundBackButton: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.offWhite : AppTheme.shared.colorSet.grey3
	}

	var backgroundButtonBack: [Color] {
		colorScheme == .light ? AppTheme.shared.colorSet.gradientPrimary : [AppTheme.shared.colorSet.black, AppTheme.shared.colorSet.black]
	}

	var titleColor: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.offWhite : AppTheme.shared.colorSet.grey3
	}
}

// MARK: - Private Func
private extension ChangePasswordContentView {
	func customBack() {
		self.presentationMode.wrappedValue.dismiss()
	}
	
	var content: AnyView {
		AnyView(changePasswordView)
	}

	func dochangPassword() {
		Task {
			do {
				let result = try await injected.interactors.changePasswordInteractor.changePassword(oldPassword: currentPassword, newPassword: newPassword).get().authenResponse?.error
				self.messageAlert = result ?? "NewPassword.Sucess".localized
				self.isShowAlert = true
			} catch {
				self.messageAlert = "\(error)"
				self.isShowAlert = true
			}
		}
	}

	func checkCurrentpass(text: String) {
		currentInvalid = injected.interactors.changePasswordInteractor.passwordValid(password: text)
		currentStyle = currentInvalid ? .normal : .error(message: "General.Password.Valid".localized)
	}

	func checkNewpass(text: String) {
		passwordInvalid = injected.interactors.changePasswordInteractor.passwordValid(password: text)
		newStyle = passwordInvalid ? .normal : .error(message: "General.Password.Valid".localized)
		if text == currentPassword {
			newStyle = (text == currentPassword) ? .error(message: "NewPassword.Diffirent.OldPass".localized) : .normal
		}

	}

	func checkConfirm(text: String) {
		confirmPasswordInvvalid = injected.interactors.changePasswordInteractor.passwordValid(password: text)
		confirmStyle = confirmPasswordInvvalid ? .normal : .error(message: "General.Password.Valid".localized)
		if text != currentPassword {
			confirmStyle = (text != currentPassword) ? .normal : .error(message: "NewPassword.Diffirent.OldPass".localized)
		}
		if text != newPassword {
			confirmInvvalid = injected.interactors.changePasswordInteractor.confirmPasswordValid(password: newPassword, confirmPassword: text)
			confirmStyle = confirmInvvalid ? .normal : .error(message: "General.ConfirmPassword.Valid".localized)
		}
	}

	func disableButton() -> Bool {
		return !(currentInvalid && passwordInvalid && confirmPasswordInvvalid && confirmInvvalid)
	}
}

// MARK: - Loading Content
private extension ChangePasswordContentView {
	var changePasswordView: some View {
		VStack(spacing: Constants.spacing) {
			Text("NewPassword.Description".localized)
				.font(AppTheme.shared.fontSet.font(style: .input2))
				.foregroundColor(foregroundBackButton)
				.frame(alignment: .leading)
			SecureTextField(secureText: $currentPassword,
							inputStyle: $currentStyle,
							inputIcon: AppTheme.shared.imageSet.lockIcon,
							placeHolder: "NewPassword.Current.PlaceHold".localized,
							keyboardType: .default,
							onEditingChanged: { isEditing in
				self.currentStyle = isEditing ? .highlighted : (currentInvalid ? .normal : .error(message: "General.Password.Valid".localized))
			})
				.onChange(of: currentPassword, perform: { text in
					checkCurrentpass(text: text)
				})

			SecureTextField(secureText: $newPassword,
							inputStyle: $newStyle,
							inputIcon: AppTheme.shared.imageSet.lockIcon,
							placeHolder: "NewPassword.New.PlaceHold".localized,
							keyboardType: .default,
							onEditingChanged: { isEditing in
				self.newStyle = isEditing ? .highlighted : (passwordInvalid ? .normal : .error(message: "General.Password.Valid".localized))
				self.newStyle = isEditing ? .highlighted : ((newPassword != currentPassword) ? .normal : .error(message: "NewPassword.Diffirent.OldPass".localized))

			})
				.onChange(of: newPassword, perform: { text in
					checkNewpass(text: text)
				})

			SecureTextField(secureText: $confirmPassword,
							inputStyle: $confirmStyle,
							inputIcon: AppTheme.shared.imageSet.lockIcon,
							placeHolder: "NewPassword.Confirm.PlaceHold".localized,
							keyboardType: .default,
							onEditingChanged: { isEditing in
				self.confirmStyle = isEditing ? .highlighted : (confirmPasswordInvvalid ? .normal : .error(message: "General.Password.Valid".localized))
				self.confirmStyle = isEditing ? .highlighted : (confirmInvvalid ? .normal : .error(message: "General.ConfirmPassword.Valid".localized))
			})
				.onChange(of: confirmPassword, perform: { text in
					checkConfirm(text: text)
				})

			RoundedButton("General.Save".localized, action: dochangPassword)
				.disabled(disableButton())
			Spacer()
		}
		.frame(maxHeight: .infinity)
		.padding(.all, Constants.padding)
	}
}

// MARK: - Interactor

// MARK: - Preview
#if DEBUG
struct ChangePasswordContentView_Previews: PreviewProvider {
	static var previews: some View {
		ChangePasswordContentView()
	}
}
#endif
