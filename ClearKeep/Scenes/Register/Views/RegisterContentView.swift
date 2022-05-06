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
	static let radius = 32.0
	static let radiusButton = 40.0
	static let heightButton = 40.0
	static let sapcing = 20.0
	static let padding = 16.0
	static let paddingHorizoltal = 40.0
	static let heightLogo = 120.0
	static let widthLogo = 160.0
	static let spacingLogo = 40.0
	static let paddingtop = 60.0
}

struct RegisterContentView: View {
	// MARK: - Variables
	@Environment(\.injected) private var injected: DIContainer
	@Environment(\.colorScheme) var colorScheme
	@Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
	@Binding var loadable: Loadable<Bool>
	@State private var email: String = ""
	@State private var password: String = ""
	@State private var displayname: String = ""
	@State private var rePassword: String = ""
	@State private var isHidden: Bool = false
	@State private var emailStyle: TextInputStyle = .default
	@State private var nameStyle: TextInputStyle = .default
	@State private var passwordStyle: TextInputStyle = .default
	@State private var rePasswordStyle: TextInputStyle = .default
	
	// MARK: - Body
	var body: some View {
		ScrollView(showsIndicators: false) {
			VStack(spacing: Constants.spacingLogo) {
				if isHidden == false {
					AppTheme.shared.imageSet.logo
						.resizable()
						.aspectRatio(contentMode: .fit)
						.frame(width: Constants.widthLogo, height: Constants.heightLogo)
						.padding(.top, Constants.paddingtop)
				}
				VStack(alignment: .center, spacing: Constants.sapcing) {
					Text("Register.Title".localized)
						.font(AppTheme.shared.fontSet.font(style: .body1))
						.frame(maxWidth: .infinity, alignment: .leading)
						.padding(.all, Constants.padding)
					VStack(spacing: Constants.sapcing) {
						CommonTextField(text: $email,
										inputStyle: $emailStyle,
										inputIcon: AppTheme.shared.imageSet.mailIcon,
										placeHolder: "General.Email".localized,
										keyboardType: .default,
										onEditingChanged: { isEditing in
							isHidden = isEditing
							if isEditing {
								emailStyle = .highlighted
							} else {
								emailStyle = .normal
							}
						})
						CommonTextField(text: $displayname,
										inputStyle: $nameStyle,
										inputIcon: AppTheme.shared.imageSet.userCheckIcon,
										placeHolder: "General.DisplayName".localized,
										keyboardType: .default,
										onEditingChanged: { isEditing in
							isHidden = isEditing
							if isEditing {
								nameStyle = .highlighted
							} else {
								nameStyle = .normal
							}
						})
					}
					SecureTextField(secureText: $password,
									inputStyle: $passwordStyle,
									inputIcon: AppTheme.shared.imageSet.lockIcon,
									placeHolder: "General.Password".localized,
									keyboardType: .default,
									onEditingChanged: { isEditing in
						isHidden = isEditing
						if isEditing {
							passwordStyle = .highlighted
						} else {
							passwordStyle = .normal
						}
					})
					SecureTextField(secureText: $rePassword,
									inputStyle: $rePasswordStyle,
									inputIcon: AppTheme.shared.imageSet.lockIcon,
									placeHolder: "General.ConfirmPassword".localized,
									keyboardType: .default,
									onEditingChanged: { isEditing in
						isHidden = isEditing
						if isEditing {
							rePasswordStyle = .highlighted
						} else {
							rePasswordStyle = .normal
						}
					})
					HStack {
						Button(action: customBack) {
							Text("Register.SignInInstead".localized)
								.padding(.all)
								.font(AppTheme.shared.fontSet.font(style: .body4))
								.foregroundColor(foregroundColorPrimary)
						}
						Spacer()
						Button(action: doRegister) {
							Text("Register.SignUp".localized)
								.frame(height: Constants.heightButton, alignment: .center)
								.padding(.horizontal, Constants.paddingHorizoltal)

						}
						.disabled(buttonStatus())
						.background(backgroundColorButton)
						.foregroundColor(foregroundColorWhite)
						.cornerRadius(Constants.radiusButton)
					}
				}
				.padding(.all, Constants.padding)
				.background(RoundedRectangle(cornerRadius: Constants.radius).fill(backgroundColorView))
				.frame(maxWidth: .infinity, alignment: .center)
			}
			.padding(.horizontal, Constants.padding)
			.padding(.top, paddingTop)
			.hideKeyboardOnTapped()
		}
	}
}

// MARK: - Private variables
private extension RegisterContentView {
	var backgroundColorButton: LinearGradient {
		buttonStatus() ? backgroundColorUnActive : backgroundColorActive
	}
	
	var backgroundColorActive: LinearGradient {
		LinearGradient(gradient: Gradient(colors: AppTheme.shared.colorSet.gradientLinear), startPoint: .leading, endPoint: .trailing)
	}
	
	var backgroundColorUnActive: LinearGradient {
		LinearGradient(gradient: Gradient(colors: AppTheme.shared.colorSet.gradientLinear.compactMap({ $0.opacity(0.5) })), startPoint: .leading, endPoint: .trailing)
	}
	
	var backgroundColorView: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.offWhite : AppTheme.shared.colorSet.grey6
	}
	
	var foregroundColorWhite: Color {
		AppTheme.shared.colorSet.offWhite
	}
	
	var foregroundColorPrimary: Color {
		AppTheme.shared.colorSet.primaryDefault
	}

	var paddingTop: CGFloat {
		isHidden ? Constants.paddingtop : 0
	}
}

// MARK: - private func
private extension RegisterContentView {
	func doRegister() {
		loadable = .isLoading(last: nil, cancelBag: CancelBag())
		Task {
			loadable = await injected.interactors.registerInteractor.register(displayName: displayname, email: email, password: password)
		}
	}
	
	func customBack() {
		self.presentationMode.wrappedValue.dismiss()
	}

	func buttonStatus() -> Bool {
		return email.isEmpty || displayname.isEmpty || password.isEmpty || rePassword.isEmpty
	}
}

// MARK: - Preview
#if DEBUG
struct RegisterContentView_Previews: PreviewProvider {
	static var previews: some View {
		RegisterContentView(loadable: .constant(.notRequested))
	}
}
#endif
