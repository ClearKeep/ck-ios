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
	@State private(set) var loadable: Loadable<ILoginModel> = .notRequested
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
		case .loaded:
			return AnyView(loadedView)
		case .failed(let error):
			return AnyView(errorView(error))
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
	
	var loadedView: some View {
		Text("Success")
	}
	
	func errorView(_ error: Error) -> some View {
		Text(error.localizedDescription)
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
