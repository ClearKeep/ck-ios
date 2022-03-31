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

public enum SocialLoginType {
	case facebook
	case google(clientId: String)
	case office(clientId: String, redirectUri: String)
}

public class SocialLoginService {
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
	
	public func loginWithFB(domain: String) {
		let fbLoginManager = LoginManager()
		fbLoginManager.logOut()
		fbLoginManager.logIn(permissions: [.publicProfile, .email], viewController: nil) { (result) in
			switch result {
			case .cancelled:
				break
			default:
				if let currentUser = AccessToken.current {
					Task {
						var request = Auth_FacebookLoginReq()
						request.accessToken = currentUser.tokenString
						request.workspaceDomain = domain
						
						let response = await channelStorage.getChannels(domain: domain).login(request)
						
						switch response {
						case .success(let data):
							print(data)
						case .failure(let error):
							print(error)
						}
					}
				}
			}
		}
	}
	
	public func loginWithGoogle(domain: String) {
		guard let topViewController = UIApplication.shared.topMostViewController(),
			  let googleSignInConfiguration = googleSignInConfiguration else { return }
		GIDSignIn.sharedInstance.signIn(with: googleSignInConfiguration, presenting: topViewController) { user, error in
			guard let idToken = user?.authentication.idToken else { return }
			
			Task {
				var request = Auth_GoogleLoginReq()
				request.idToken = idToken
				request.workspaceDomain = domain
				
				let response = await channelStorage.getChannels(domain: domain).login(request)
				
				switch response {
				case .success(let data):
					print(data)
				case .failure(let error):
					print(error)
				}
			}
		}
	}
	
	public func loginWithOffice(domain: String) {
		guard let topViewController = UIApplication.shared.topMostViewController() else { return }
		webViewParamaters = MSALWebviewParameters(authPresentationViewController: topViewController)
		
		guard let account = try? applicationContext?.allAccounts().first else {
			self.acquireTokenInteractively(domain: domain)
			return
		}
		
		self.acquireTokenSilently(account, domain: domain)
	}
}

// MARK: - Signout
extension SocialLoginService {
	func signOutFacebookAccount() {
		let loginManager = LoginManager()
		loginManager.logOut()
	}
	
	func signOutGoogleAccount() {
		GIDSignIn.sharedInstance.signOut()
	}
	
	func signOutO365() {
		guard let applicationContext = self.applicationContext else { return }
		
		let accounts = try? applicationContext.allAccounts()
		guard let account = accounts?.first else { return }
		
		try? applicationContext.remove(account)
	}
}

// MARK: - Private
private extension SocialLoginService {
	func initGoogleSignIn(clientId: String) {
		googleSignInConfiguration = GIDConfiguration(clientID: clientId)
	}
	
	func initMSAL(clientId: String, redirectUri: String) {
		guard let authorityURL = URL(string: kAuthority) else {
			print("Unable to create authority URL")
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
	
	func acquireTokenInteractively(domain: String) {
		guard let applicationContext = applicationContext else { return }
		guard let webViewParameters = webViewParamaters else { return }

		let parameters = MSALInteractiveTokenParameters(scopes: ["user.read"], webviewParameters: webViewParameters)
		parameters.promptType = .selectAccount
		
		applicationContext.acquireToken(with: parameters) { (result, error) in
			if let error = error {
				print("Could not acquire token: \(error)")
				return
			}
			
			guard let result = result else {
				print("Could not acquire token: No result returned")
				return
			}
			
			Task {
				var request = Auth_OfficeLoginReq()
				request.accessToken = result.accessToken
				request.workspaceDomain = domain
				
				let response = await channelStorage.getChannels(domain: domain).login(request)
				
				switch response {
				case .success(let data):
					print(data)
				case .failure(let error):
					print(error)
				}
			}
		}
	}
	
	func acquireTokenSilently(_ account: MSALAccount, domain: String) {
		guard let applicationContext = self.applicationContext else { return }
		
		let parameters = MSALSilentTokenParameters(scopes: ["user.read"], account: account)
		
		applicationContext.acquireTokenSilent(with: parameters) { (result, error) in
			if let error = error {
				let nsError = error as NSError
				if nsError.domain == MSALErrorDomain {
					if nsError.code == MSALError.interactionRequired.rawValue {
						DispatchQueue.main.async {
							self.acquireTokenInteractively(domain: domain)
						}
						return
					}
				}
				print("Could not acquire token silently: \(error)")
				return
			}
			guard let result = result else {
				print("Could not acquire token: No result returned")
				return
			}
			
			Task {
				var request = Auth_OfficeLoginReq()
				request.accessToken = result.accessToken
				request.workspaceDomain = domain
				
				let response = await channelStorage.getChannels(domain: domain).login(request)
				
				switch response {
				case .success(let data):
					print(data)
				case .failure(let error):
					print(error)
				}
			}
		}
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
