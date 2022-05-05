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
	static let radius = 20.0
	static let sapcing = 20.0
	static let padding = 10.0
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
	@State private var emailStyle: TextInputStyle = .default
	@State private var nameStyle: TextInputStyle = .default
	@State private var passwordStyle: TextInputStyle = .default
	@State private var rePasswordStyle: TextInputStyle = .default

	// MARK: - Body
	var body: some View {
		GroupBox(label:
					Text("Register.Title".localized)
					.font(AppTheme.shared.fontSet.font(style: .body1))
					.frame(maxWidth: .infinity, alignment: .leading)
					.padding(.all, Constants.padding)) {
			VStack(alignment: .center, spacing: Constants.sapcing) {
				nomalTextfield
				secureTexfield
				button
			}
			.frame(maxWidth: .infinity, alignment: .center)
			.padding(.all, Constants.padding)
		}
	}
}

// MARK: - Private variables
private extension RegisterContentView {
	var backgroundColorView: LinearGradient {
		LinearGradient(gradient: Gradient(colors: backgroundColorButton), startPoint: .leading, endPoint: .trailing)
	}
	
	var backgroundColorButton: [Color] {
		AppTheme.shared.colorSet.gradientPrimary
	}
	
	var foregroundColorWhite: Color {
		AppTheme.shared.colorSet.offWhite
	}
	
	var foregroundColorPrimary: Color {
		AppTheme.shared.colorSet.primaryDefault
	}
}

// MARK: - Private
private extension RegisterContentView {
	
	var button: AnyView {
		AnyView(buttonView)
	}

	var secureTexfield: AnyView {
		AnyView(secureView)
	}

	var nomalTextfield: AnyView {
		AnyView(nomalTextfieldView)
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

}

// MARK: - Loading Content
private extension RegisterContentView {
	var buttonView: some View {
		HStack {
			Button("Register.SignInInstead".localized) {
				customBack()
			}
			.foregroundColor(foregroundColorPrimary)
			Spacer()
			Button("Register.SignUp".localized) {
				doRegister()
			}
			.frame(maxWidth: .infinity, alignment: .center)
			.padding(.all, Constants.padding)
			.background(backgroundColorView)
			.foregroundColor(foregroundColorWhite)
			.cornerRadius(Constants.radius)
		}
	}
	
	var secureView: some View {
		VStack(spacing: Constants.sapcing) {
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
		}
	}
	
	var nomalTextfieldView: some View {
		VStack(spacing: Constants.sapcing) {
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
			CommonTextField(text: $displayname,
							inputStyle: $nameStyle,
							inputIcon: AppTheme.shared.imageSet.userIcon,
							placeHolder: "General.Displayname".localized,
							keyboardType: .default,
							onEditingChanged: { isEditing in
				if isEditing {
					nameStyle = .highlighted
				} else {
					nameStyle = .normal
				}
			})
		}
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
