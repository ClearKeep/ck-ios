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
	@Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
	@State private(set) var loadable: Loadable<IAuthenticationModel> = .notRequested
	@State private(set) var customServer: CustomServer = CustomServer()
	@State private var password: String = ""
	let inspection = ViewInspector<Self>()
	@State private(set) var navigateToHome: Bool = false

	// MARK: - Init
	
	// MARK: - Body
	var body: some View {
		NavigationView {
			content
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
	
	var content: AnyView {
		switch loadable {
		case .notRequested:
			return AnyView(notRequestedView)
		case .isLoading:
			return AnyView(loadingView)
		case .loaded(let data):
			return loadedView(data)
		case .failed(let error):
			if let errorResponse = error as? IServerError,
			   errorResponse.message == nil && errorResponse.name == nil && errorResponse.status == nil {
				return AnyView(notRequestedView)
			}
			return AnyView(errorView(LoginViewError(error)))
		}
	}
}

// MARK: - Loading Content
private extension LoginView {
	var notRequestedView: some View {
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
				LoginContentView(loadable: $loadable, customServer: $customServer, password: $password, navigateToHome: navigateToHome)
				Spacer()
			}
			.padding(.horizontal, Constants.paddingHorizontal)
		}
		.hiddenNavigationBarStyle()
	}
	
	var loadingView: some View {
		notRequestedView.progressHUD(true)
	}
	
	func loadedView(_ data: IAuthenticationModel) -> AnyView {
		if let normalLogin = data.normalLogin {
			let accessToken = normalLogin.accessToken ?? ""
			if accessToken.isEmpty {
				return AnyView(VStack {
					NavigationLink(destination: TwoFactorView(otpHash: normalLogin.otpHash ?? "", userId: normalLogin.sub ?? "", domain: normalLogin.workspaceDomain ?? "", password: password, twoFactorType: .login), isActive: .constant(true), label: {})
					notRequestedView
				})
			} else {
				if navigateToHome {
					self.presentationMode.wrappedValue.dismiss()
				}
				if let token = UserDefaults.standard.data(forKey: "keySaveTokenPushNotification") {
					injected.interactors.homeInteractor.registerToken(token)
				}
				return AnyView(Text(""))
			}
		}
		
		if let socialLogin = data.socialLogin,
		   let userName = socialLogin.userName {
			switch socialLogin.requireAction {
			case "register_pincode":
				return AnyView(VStack {
					NavigationLink(destination: SocialView(userName: userName, socialStyle: .setSecurity, customServer: $customServer), isActive: .constant(true), label: {})
					notRequestedView
				})
			case "verify_pincode":
				return AnyView(VStack {
					NavigationLink(destination: SocialView(userName: userName, resetToken: socialLogin.resetPincodeToken ?? "", pinCode: nil, socialStyle: .verifySecurity, customServer: $customServer), isActive: .constant(true), label: {})
					notRequestedView
				})
			default:
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
	var backgroundArlert: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.warningLight : AppTheme.shared.colorSet.primaryDefault
	}
}

private extension LoginView {
	func subscribeAndListen() {
		injected.interactors.homeInteractor.subscribeAndListenServers()
	}
}

// MARK: - Preview
#if DEBUG
struct LoginView_Previews: PreviewProvider {
	static var previews: some View {
		LoginView()
	}
}
#endif
