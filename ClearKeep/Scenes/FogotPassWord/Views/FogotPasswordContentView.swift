//
//  FogotPasswordContentView.swift
//  ClearKeep
//
//  Created by MinhDev on 22/03/2022.
//

import SwiftUI
import CommonUI
import Common

private enum Constants {
	static let radius = 40.0
	static let spacing = 40.0
	static let spacingHstack = 23.0
	static let padding = 30.0
	static let paddingTextfield = 24.0
	static let paddingButton = 10.0
	static let paddingText = 10.0
	static let paddingtop = 90.0
	static let paddingLeding = 16.0
}

struct FogotPasswordContentView: View {
	// MARK: - Constants
	private let inspection = ViewInspector<Self>()

	// MARK: - Variables
	@Environment(\.colorScheme) var colorScheme
	@Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
	@Environment(\.injected) private var injected: DIContainer
	@State private(set) var email: String = ""
	@State private(set) var domain: String = ""
	@State private(set) var emailStyle: TextInputStyle = .default
	@State private(set) var showingNewPass: Bool = false

	// MARK: - Body
	var body: some View {
		VStack(spacing: Constants.spacing) {
			VStack(alignment: .leading, spacing: Constants.padding) {
				Text("ForgotPass.TitleMail".localized)
					.font(AppTheme.shared.fontSet.font(style: .input2))
					.foregroundColor(foregroundBackButton)
					.frame(maxWidth: .infinity, alignment: .leading)
					.padding(.horizontal, Constants.paddingText)
			}
			VStack(spacing: Constants.paddingTextfield) {
				CommonTextField(text: $email,
								inputStyle: $emailStyle,
								inputIcon: AppTheme.shared.imageSet.mailIcon,
								placeHolder: "General.Email".localized,
								keyboardType: .default,
								onEditingChanged: { isEditing in
					emailStyle = isEditing ? .default : .normal
				})
				NavigationLink(
					destination: NewPasswordView(),
					isActive: $showingNewPass,
					label: {
						Button {
							self.showingNewPass = true
						} label: {
							Text("ForgotPass.Resetpassword".localized)
								.font(AppTheme.shared.fontSet.font(style: .body3))
								.foregroundColor(foregroundButton)
						}.frame(maxWidth: .infinity, alignment: .center)
							.padding(.all, Constants.paddingButton)
							.background(backgroundButton)

							.cornerRadius(Constants.radius)
					})	.disabled(email.isEmpty)
			}
			Spacer()
		}
		.frame(maxWidth: .infinity, alignment: .center)
		.padding(.horizontal, Constants.paddingLeding)
		.background(backgroundViewColor)
		.edgesIgnoringSafeArea(.all)
	}
}

// MARK: - Private
private extension FogotPasswordContentView {

	var backgroundButton: Color {
		email.isEmpty ? backgroundButtonUnActive : backgroundButtonActive
	}

	var backgroundButtonUnActive: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.offWhite.opacity(0.5) : AppTheme.shared.colorSet.primaryLight.opacity(0.5)
	}

	var backgroundButtonActive: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.offWhite : AppTheme.shared.colorSet.primaryLight
	}

	var backgroundViewColor: LinearGradient {
		colorScheme == .light ? backgroundColorGradient : backgroundColorBlack
	}

	var backgroundColorBlack: LinearGradient {
		LinearGradient(gradient: Gradient(colors: AppTheme.shared.colorSet.gradientBlack), startPoint: .leading, endPoint: .trailing)
	}

	var backgroundColorGradient: LinearGradient {
		LinearGradient(gradient: Gradient(colors: AppTheme.shared.colorSet.gradientPrimary), startPoint: .leading, endPoint: .trailing)
	}

	var foregroundButton: Color {
		email.isEmpty ? foregroundButtonUnActive : foregroundButtonActive
	}

	var foregroundButtonActive: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.primaryDefault : AppTheme.shared.colorSet.offWhite
	}

	var foregroundButtonUnActive: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.primaryDefault.opacity(0.5) : AppTheme.shared.colorSet.offWhite.opacity(0.5)
	}

	var foregroundBackButton: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.offWhite : AppTheme.shared.colorSet.grey3
	}

}

// MARK: - Private Func
private extension FogotPasswordContentView {

	func doFogotPassword() {
		Task {
			await injected.interactors.fogotPasswordInteractor.recoverPassword(email: email, domain: domain)
		}
	}

}
// MARK: - Preview
#if DEBUG
struct FogotPasswordContentView_Previews: PreviewProvider {
	static var previews: some View {
		FogotPasswordContentView(emailStyle: .default)
	}
}
#endif
