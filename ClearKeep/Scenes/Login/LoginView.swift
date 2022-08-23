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
	static let paddingHorizontal = 24.0
}

struct LoginView: View {
	// MARK: - Variables
	@Environment(\.injected) private var injected: DIContainer
	@Environment(\.colorScheme) var colorScheme
	@Environment(\.joinServerClosure) var joinServerClosure: JoinServerClosure
	@Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
	@State private(set) var loadable: Loadable<IAuthenticationModel> = .notRequested
	@State private(set) var customServer: CustomServer = CustomServer()
	let inspection = ViewInspector<Self>()
	@State private(set) var navigateToHome: Bool = false
	@Binding var rootIsActive: Bool
	// MARK: - Init
	
	// MARK: - Body
	var body: some View {
		NavigationView {
			ScrollView(showsIndicators: false) {
				VStack(spacing: Constants.spacing) {
					Spacer()
					if navigateToHome {
						BackButton({ self.presentationMode.wrappedValue.dismiss() })
							.frame(maxWidth: .infinity, maxHeight: 40.0, alignment: .leading)
					}
					AppLogo()
						.frame(width: Constants.widthLogo, height: Constants.heightLogo)
					if customServer.isSelectedCustomServer {
						HStack {
							AppTheme.shared.imageSet.alertIcon
								.foregroundColor(backgroundArlert)
							Text("AdvancedServer.Alert".localized)
								.foregroundColor(backgroundArlert)
								.font(AppTheme.shared.fontSet.font(style: .input3))
						}
					}
					LoginContentView(customServer: $customServer, dismiss: self.dismiss, navigateToHome: navigateToHome)
					Spacer()
				}
				.padding(.horizontal, Constants.paddingHorizontal)
			}
			.onReceive(inspection.notice) { inspection.visit(self, $0) }
			.onReceive(newServerDomainStateUpdate) { newServerDomain in
				if let newServerDomain = newServerDomain {
					customServer = CustomServer(isSelectedCustomServer: true, customServerURL: newServerDomain)
				}
			}
			.hideKeyboardOnTapped()
			.hiddenNavigationBarStyle()
			.grandientBackground()
			.edgesIgnoringSafeArea(.all)
		}
		.hiddenNavigationBarStyle()
	}
}

// MARK: - Private
private extension LoginView {
	var newServerDomainStateUpdate: AnyPublisher<String?, Never> {
		injected.appState.updates(for: \.authentication.newServerDomain)
	}
//
//	var content: AnyView {
//		switch loadable {
//		case .notRequested:
//			return AnyView(notRequestedView)
//		case .isLoading:
//			return AnyView(loadingView)
//		case .loaded(let data):
//			return loadedView(data)
//		case .failed(let error):
//			if let errorResponse = error as? IServerError,
//			   errorResponse.message == nil && errorResponse.name == nil && errorResponse.status == nil {
//				return AnyView(notRequestedView)
//			}
//			return AnyView(errorView(LoginViewError(error)))
//		}
//	}
}

// MARK: - Displaying Content
private extension LoginView {
	
}

// MARK: - Interactors
private extension LoginView {
}

// MARK: - Support Variables
private extension LoginView {
	var backgroundArlert: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.warningLight : AppTheme.shared.colorSet.primaryDefault
	}
}

private extension LoginView {
	func subscribeAndListen() {
		injected.interactors.homeInteractor.subscribeAndListenServers()
	}
	
	func dismiss() {
		if navigateToHome {
			self.rootIsActive = false
			joinServerClosure?(customServer.customServerURL)
		}
	}
}

// MARK: - Preview
#if DEBUG
struct LoginView_Previews: PreviewProvider {
	static var previews: some View {
		LoginView(rootIsActive: .constant(false))
	}
}
#endif
