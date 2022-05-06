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
import Model
import Networking

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
	@State private(set) var loadable: Loadable<IAuthenticationModel> = .notRequested
	let inspection = ViewInspector<Self>()

	// MARK: - Init
	
	// MARK: - Body
	var body: some View {
		NavigationView {
			content
				.onReceive(inspection.notice) { inspection.visit(self, $0) }
				.navigationBarTitle("")
				.navigationBarHidden(true)
		}
	}
}

// MARK: - Private
private extension LoginView {
	var content: AnyView {
		switch loadable {
		case .notRequested:
			return AnyView(notRequestedView)
		case .isLoading:
			return AnyView(loadingView)
		case .loaded(let data):
			return loadedView(data)
		case .failed(let error):
			return AnyView(errorView(LoginViewError(error)))
		}
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
				LoginContentView(loadable: $loadable)
				Spacer()
			}
			.padding(.leading, Constants.paddingVertical)
			.padding(.trailing, Constants.paddingVertical)
		}
		.background(background)
		.edgesIgnoringSafeArea(.all)
	}
	
	var loadingView: some View {
		notRequestedView.modifier(LoadingIndicatorViewModifier())
	}
	
	func loadedView(_ data: IAuthenticationModel) -> AnyView {
		if let normalLogin = data.normalLogin {
			return AnyView(Text(normalLogin.workspaceDomain ?? ""))
		}
		
		if let socialLogin = data.socialLogin {
			if socialLogin.requireAction == "register_pincode" {
				return AnyView(VStack {
					NavigationLink(destination: SocialView(socialStyle: .setSecurity), isActive: .constant(true), label: {})
					notRequestedView
				})
			} else {
				return AnyView(Text(socialLogin.requireAction ?? ""))
			}
		}
		
		return AnyView(errorView(LoginViewError.unknownError(errorCode: nil)))
	}
	
	func errorView(_ error: LoginViewError) -> some View {
		return notRequestedView
			.alert(isPresented: .constant(true)) {
				Alert(title: Text(error.title),
					  message: Text(error.message),
					  dismissButton: .default(Text(error.primaryButtonTitle)))
			}
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
