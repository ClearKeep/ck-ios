//
//  LoginView.swift
//  ClearKeep
//
//  Created by đông on 07/03/2022.
//

import SwiftUI
import Combine
import Common
import CommonUI

private enum Constants {
	static let minSpacer = 50.0
	static let heightLogo = 120.0
	static let widthLogo = 150.0
	static let spacing = 30.0
	static let paddingVertical = 14.0
	static let paddingHorizontal = 24.0
}

struct LoginView: View {
	// MARK: - Variables
	@Environment(\.injected) private var injected: DIContainer
	@Environment(\.colorScheme) var colorScheme
	@State private(set) var samples: Loadable<[ILoginModel]>
	@State private(set) var email: String
	@State private(set) var password: String
	@State private(set) var emailStyle: TextInputStyle = .default
	@State private(set) var passwordStyle: TextInputStyle = .default
	let inspection = ViewInspector<Self>()

	// MARK: - Init
	init(samples: Loadable<[ILoginModel]> = .notRequested,
		 email: String = "",
		 password: String = "",
		 inputStyle: TextInputStyle = .default) {
		self._samples = .init(initialValue: samples)
		self._email = .init(initialValue: email)
		self._password = .init(initialValue: password)
		self._emailStyle = .init(initialValue: inputStyle)
		self._passwordStyle = .init(initialValue: inputStyle)
	}
	
	// MARK: - Body
	var body: some View {
		NavigationView {
			content
				.onReceive(inspection.notice) { inspection.visit(self, $0) }
		}
		.modifier(NavigationModifier())
	}
}

// MARK: - Private
private extension LoginView {
	var content: AnyView {
		AnyView(notRequestedView)
	}
}

// MARK: - Loading Content
private extension LoginView {
	var notRequestedView: some View {
		ScrollView {
			background
			VStack(spacing: Constants.spacing) {
				Spacer(minLength: Constants.minSpacer)
				AppTheme.shared.imageSet.logo
					.resizable()
					.aspectRatio(contentMode: .fit)
					.frame(width: Constants.widthLogo, height: Constants.heightLogo)
				LoginContentView(email: $email, password: $password, emailStyle: $emailStyle, passwordStyle: $passwordStyle)
				Spacer()
			}
			.padding(.leading, Constants.paddingVertical)
			.padding(.trailing, Constants.paddingVertical)
		}
		.background(background)
		.edgesIgnoringSafeArea(.all)
	}
}

// MARK: - Displaying Content
private extension LoginView {

}

// MARK: - Interactors
private extension LoginView {
}

// MARK: - Support Variables
private extension LoginView {
	var background: LinearGradient {
		colorScheme == .light ? backgroundGradientPrimary : backgroundBlack
	}
	var backgroundBlack: LinearGradient {
		LinearGradient(gradient: Gradient(colors: [AppTheme.shared.colorSet.black, AppTheme.shared.colorSet.black]), startPoint: .leading, endPoint: .trailing)
	}
	var backgroundGradientPrimary: LinearGradient {
		LinearGradient(gradient: Gradient(colors: AppTheme.shared.colorSet.gradientPrimary), startPoint: .leading, endPoint: .trailing)
	}
}

// MARK: - Preview
#if DEBUG
struct LoginView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView(container: .preview)
	}
}
#endif
