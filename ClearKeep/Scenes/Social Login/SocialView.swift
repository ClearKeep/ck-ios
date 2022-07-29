//
//  SocialView.swift
//  ClearKeep
//
//  Created by đông on 18/03/2022.
//

import SwiftUI
import Combine
import Common
import CommonUI
import Model

private enum Constants {
	static let inputSpacing = 10.0
	static let inputPaddingTop = 32.0
	static let descriptionHeight = 24.0
	static let submitPaddingTop = 104.0
	static let paddingHorizontal = 16.0
}

struct SocialView: View {
	// MARK: - Variables
	@Environment(\.presentationMode) var presentationMode
	@Environment(\.injected) private var injected: DIContainer
	@Environment(\.colorScheme) var colorScheme
	@Binding var customServer: CustomServer
	@State private(set) var loadable: Loadable<IAuthenticationModel> = .notRequested
	@State private(set) var security: String = ""
	@State private(set) var securityStyle: TextInputStyle = .default
	@State private(set) var isNext: Bool = false
	let userName: String
	let socialStyle: SocialCommonStyle
	let inspection = ViewInspector<Self>()
	
	// MARK: - Init
	init(userName: String, socialStyle: SocialCommonStyle, customServer: Binding<CustomServer>) {
		self.userName = userName
		self.socialStyle = socialStyle
		self._customServer = customServer
	}
	
	// MARK: - Body
	var body: some View {
		content
			.padding(.horizontal, Constants.paddingHorizontal)
			.onReceive(inspection.notice) { inspection.visit(self, $0) }
			.applyNavigationBarPlainStyle(title: socialStyle.buttonBack,
										  titleColor: titleColor,
										  leftBarItems: {
				BackButton(customBack)
			},
										  rightBarItems: {
				Spacer()
			})
			.grandientBackground()
			.hideKeyboardOnTapped()
			.keyboardAdaptive()
			.edgesIgnoringSafeArea(.all)
	}
}

// MARK: - Private
private extension SocialView {
	var content: AnyView {
		switch loadable {
		case .notRequested:
			return AnyView(notRequestedView)
		case .isLoading:
			return AnyView(loadingView)
		case .loaded(let data):
			return AnyView(loadedView(data))
		case .failed(let error):
			return AnyView(errorView(SocialViewError(error)))
		}
	}
}

// MARK: - Loading Content
private extension SocialView {
	var notRequestedView: some View {
		ScrollView(showsIndicators: false) {
			VStack {
				Text(socialStyle.title)
					.font(AppTheme.shared.fontSet.font(style: .input2))
					.foregroundColor(titleColor)
					.frame(maxWidth: .infinity, alignment: .leading)
				VStack(alignment: .center, spacing: Constants.inputSpacing) {
					SecureTextField(secureText: $security,
									inputStyle: $securityStyle,
									inputIcon: AppTheme.shared.imageSet.lockIcon,
									placeHolder: socialStyle.textInput,
									keyboardType: .numberPad,
									onEditingChanged: { isEditing in
						securityStyle = isEditing ? .highlighted : .normal
					})
					if socialStyle == .setSecurity {
						Text(socialStyle.textInputDescription)
							.font(AppTheme.shared.fontSet.font(style: .body3))
							.foregroundColor(titleColor)
							.multilineTextAlignment(.center)
							.frame(height: Constants.descriptionHeight)
					}
				}
				.padding(.top, Constants.inputPaddingTop)
				NavigationLink(
					destination: socialStyle.nextView(userName: userName, customServer: $customServer),
					isActive: $isNext,
					label: {
						RoundedButton(socialStyle.buttonNext, disabled: .constant(security.isEmpty), action: submitAction)
					})
				.padding(.top, socialStyle == .setSecurity ? Constants.submitPaddingTop - Constants.descriptionHeight : Constants.submitPaddingTop)
				Spacer()
			}
		}.frame(maxWidth: .infinity)
		
	}
	
	var loadingView: some View {
		notRequestedView.progressHUD(true)
	}
	
	func loadedView(_ data: IAuthenticationModel) -> AnyView {
		if let normalLogin = data.normalLogin {
			return AnyView(Text(normalLogin.workspaceDomain ?? ""))
		}
		return AnyView(errorView(SocialViewError.unknownError(errorCode: nil)))
	}
	
	func errorView(_ error: SocialViewError) -> some View {
		return notRequestedView
			.alert(isPresented: .constant(true)) {
				Alert(title: Text(error.title),
					  message: Text(error.message),
					  dismissButton: .default(Text(error.primaryButtonTitle)))
			}
	}
}

// MARK: - Support Variables
private extension SocialView {
	var titleColor: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.offWhite : AppTheme.shared.colorSet.grey3
	}
}

// MARK: - Private Func
private extension SocialView {
	func customBack() {
		self.presentationMode.wrappedValue.dismiss()
	}
}

// MARK: - Interactors
private extension SocialView {
	func submitAction() {
		Task {
			switch socialStyle {
			case .setSecurity:
				isNext = true
			case .confirmSecurity:
				loadable = .isLoading(last: nil, cancelBag: CancelBag())
				loadable = await injected.interactors.socialInteractor.registerSocialPin(userName: userName, rawPin: security, customServer: customServer)
			case .verifySecurity:
				loadable = .isLoading(last: nil, cancelBag: CancelBag())
				loadable = await injected.interactors.socialInteractor.verifySocialPin(userName: userName, rawPin: security, customServer: customServer)
			}
		}
	}
}

struct SocialView_Previews: PreviewProvider {
	static var previews: some View {
		SocialView(userName: "", socialStyle: .confirmSecurity, customServer: .constant(CustomServer()))
	}
}
