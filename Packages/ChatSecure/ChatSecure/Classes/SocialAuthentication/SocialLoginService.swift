//
//  SocialLoginService.swift
//  ChatSecure
//
//  Created by NamNH on 23/03/2022.
//

import Foundation
import GoogleSignIn
import FBSDKCoreKit
import FBSDKLoginKit
import MSAL
import Networking

public protocol ISocialAuthenticationService {
	func signInWithFB(domain: String) async -> Result<Auth_SocialLoginRes, Error>
	func signInWithGoogle(domain: String) async -> Result<Auth_SocialLoginRes, Error>
	func signInWithOffice(domain: String) async -> Result<Auth_SocialLoginRes, Error>
	func signOutFacebookAccount()
	func signOutGoogleAccount()
	func signOutO365()
}

public enum SocialLoginType {
	case facebook
	case google(clientId: String)
	case office(clientId: String, redirectUri: String)
}

public class SocialAuthenticationService {
	private var googleSignInConfiguration: GIDConfiguration?
	private var applicationContext: MSALPublicClientApplication?
	private var webViewParamaters: MSALWebviewParameters?
	
	let kGraphEndpoint = "https://graph.microsoft.com/v1.0/me/"
	let kAuthority = "https://login.microsoftonline.com/common"
	
	init() {}
	
	public convenience init(_ socicalLoginTypes: [SocialLoginType]) {
		self.init()
		socicalLoginTypes.forEach { type in
			switch type {
			case .facebook:
				break
			case .google(let clientId):
				initGoogleSignIn(clientId: clientId)
			case .office(let clientId, let redirectUri):
				initMSAL(clientId: clientId, redirectUri: redirectUri)
			}
		}
	}
}

// MARK: - ISocialAuthenticationService
extension SocialAuthenticationService: ISocialAuthenticationService {
	public func signInWithFB(domain: String) async -> Result<Auth_SocialLoginRes, Error> {
		let fbLoginManager = LoginManager()
		fbLoginManager.logOut()
		
		let result: LoginResult = await withCheckedContinuation({ continuation in
			DispatchQueue.main.async {
				fbLoginManager.logIn(permissions: [.publicProfile, .email], viewController: nil) { result in
					return continuation.resume(returning: result)
				}
			}
		})
		
		switch result {
		case .cancelled:
			return .failure(ServerError.cancel)
		default:
			if let currentUser = AccessToken.current {
				var request = Auth_FacebookLoginReq()
				request.accessToken = currentUser.tokenString
				request.workspaceDomain = domain
				return await channelStorage.getChannel(domain: domain).login(request)
			} else {
				return .failure(ServerError.unknown)
			}
		}
	}
	
	public func signInWithGoogle(domain: String) async -> Result<Auth_SocialLoginRes, Error> {
		guard let topViewController = await UIApplication.shared.topMostViewController(),
			  let googleSignInConfiguration = googleSignInConfiguration else {
			return .failure(ServerError.unknown)
		}
		let result: Result<String, Error> = await withCheckedContinuation({ continuation in
			DispatchQueue.main.async {
				GIDSignIn.sharedInstance.signIn(with: googleSignInConfiguration, presenting: topViewController) { user, error in
					if let error = error { return continuation.resume(returning: .failure(error)) }
					guard let idToken = user?.authentication.idToken else { return continuation.resume(returning: .failure(ServerError.unknown)) }
					return continuation.resume(returning: .success(idToken))
				}
			}
		})
		
		switch result {
		case .success(let idToken):
			var request = Auth_GoogleLoginReq()
			request.idToken = idToken
			request.workspaceDomain = domain
			
			return await channelStorage.getChannel(domain: domain).login(request)
		case .failure(let error):
			if case GIDSignInError.canceled = error {
				return .failure(ServerError.cancel)
			}
			return .failure(error)
		}
	}
	
	public func signInWithOffice(domain: String) async -> Result<Auth_SocialLoginRes, Error> {
		guard let topViewController = await UIApplication.shared.topMostViewController() else {
			return .failure(ServerError.unknown)
		}
		webViewParamaters = MSALWebviewParameters(authPresentationViewController: topViewController)
		
		var result: Result<MSALResult, Error>?
		if let account = try? applicationContext?.allAccounts().first {
			result = await acquireTokenSilently(account, domain: domain)
		} else {
			result = await acquireTokenInteractively(domain: domain)
		}
		
		switch result {
		case .success(let msalResult):
			var request = Auth_OfficeLoginReq()
			request.accessToken = msalResult.accessToken
			request.workspaceDomain = domain
			
			return await channelStorage.getChannel(domain: domain).login(request)
		case .failure(let error):
			if let error = error as NSError?,
			   let errorCode = MSALError(rawValue: error.code),
			   errorCode == MSALError.userCanceled {
				return .failure(ServerError.cancel)
			}

			return .failure(error)
		case .none:
			return .failure(ServerError.unknown)
		}
	}
	
	public func signOutFacebookAccount() {
		let loginManager = LoginManager()
		loginManager.logOut()
	}
	
	public func signOutGoogleAccount() {
		GIDSignIn.sharedInstance.signOut()
	}
	
	public func signOutO365() {
		guard let applicationContext = self.applicationContext else { return }
		
		let accounts = try? applicationContext.allAccounts()
		guard let account = accounts?.first else { return }
		
		try? applicationContext.remove(account)
	}
}

// MARK: - Private
private extension SocialAuthenticationService {
	func initGoogleSignIn(clientId: String) {
		googleSignInConfiguration = GIDConfiguration(clientID: clientId)
	}
	
	func initMSAL(clientId: String, redirectUri: String) {
		guard let authorityURL = URL(string: kAuthority) else {
			return
		}
		do {
			let authority = try MSALAADAuthority(url: authorityURL)
			
			let msalConfiguration = MSALPublicClientApplicationConfig(clientId: clientId,
																	  redirectUri: redirectUri,
																	  authority: authority)
			applicationContext = try MSALPublicClientApplication(configuration: msalConfiguration)
		} catch {
			print(error)
		}
	}
	
	func acquireTokenInteractively(domain: String) async -> Result<MSALResult, Error> {
		guard let applicationContext = applicationContext else { return .failure(ServerError.unknown) }
		guard let webViewParameters = webViewParamaters else { return .failure(ServerError.unknown) }
		
		let parameters = MSALInteractiveTokenParameters(scopes: ["user.read"], webviewParameters: webViewParameters)
		parameters.promptType = .selectAccount
		
		return await withCheckedContinuation({ continuation in
			DispatchQueue.main.async {
				applicationContext.acquireToken(with: parameters) { (result, error) in
					if let error = error {
						return continuation.resume(returning: .failure(error))
					}
					
					guard let result = result else {
						return continuation.resume(returning: .failure(ServerError.unknown))
					}
					return continuation.resume(returning: .success(result))
				}
			}
		})
	}
	
	func acquireTokenSilently(_ account: MSALAccount, domain: String) async -> Result<MSALResult, Error> {
		guard let applicationContext = self.applicationContext else { return .failure(ServerError.unknown) }
		guard let webViewParameters = webViewParamaters else { return .failure(ServerError.unknown) }
		
		let parameters = MSALSilentTokenParameters(scopes: ["user.read"], account: account)
		
		return await withCheckedContinuation({ continuation in
			DispatchQueue.main.async {
				applicationContext.acquireTokenSilent(with: parameters) { [weak self] (result, error) in
					guard let self = self else { return continuation.resume(returning: .failure(ServerError.unknown)) }
					if let error = error {
						let nsError = error as NSError
						if nsError.domain == MSALErrorDomain {
							if nsError.code == MSALError.interactionRequired.rawValue {
								let parameters = MSALInteractiveTokenParameters(scopes: ["user.read"], webviewParameters: webViewParameters)
								parameters.promptType = .selectAccount
								applicationContext.acquireToken(with: parameters) { (result, error) in
									if let error = error {
										return continuation.resume(returning: .failure(error))
									}
									guard let result = result else {
										return continuation.resume(returning: .failure(ServerError.unknown))
									}
									return continuation.resume(returning: .success(result))
								}
							} else {
								continuation.resume(returning: .failure(nsError))
							}
						} else {
							continuation.resume(returning: .failure(error))
						}
					}
					guard let result = result else {
						continuation.resume(returning: .failure(ServerError.unknown))
						return
					}
					continuation.resume(returning: .success(result))
				}
			}
		})
	}
}

extension UIViewController {
	func topMostViewController() -> UIViewController? {
		if presentedViewController == nil {
			return self
		}
		
		if let navigation = presentedViewController as? UINavigationController, let nav = navigation.visibleViewController?.topMostViewController() {
			return nav
		}
		
		if let tab = presentedViewController as? UITabBarController {
			if let selectedTab = tab.selectedViewController {
				return selectedTab.topMostViewController()
			}
			return tab.topMostViewController()
		}
		return presentedViewController?.topMostViewController()
	}
}

extension UIApplication {
	func topMostViewController() -> UIViewController? {
		let keywindow = UIApplication.shared.windows.first { $0.isKeyWindow }
		return keywindow?.rootViewController?.topMostViewController()
	}
}
