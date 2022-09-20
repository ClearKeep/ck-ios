//
//  FogotPasswordView.swift
//  ClearKeep
//
//  Created by MinhDev on 22/03/2022.
//

import SwiftUI
import Common
import CommonUI

private enum Constants {
	static let imageScale = 40.0
}

struct FogotPasswordView: View {
	// MARK: - Constants
	private let inspection = ViewInspector<Self>()

	// MARK: - Variables
	@Environment(\.injected) private var injected: DIContainer
	@Environment(\.colorScheme) var colorScheme
	@Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
	@Binding var customServer: CustomServer
	@State private var showAlert: Bool = false
	@State private var isLoading = false
	@State private var isShowError: Bool = false
	@State private var error: FogotPasswordViewError?
	@State private(set) var loadable: Loadable<Bool> = .notRequested {
		didSet {
			switch loadable {
			case .loaded:
				isLoading = false
				self.showAlert = true
			case .failed(let error):
				isLoading = false
				self.error = FogotPasswordViewError(error)
				self.isShowError = true
			case .isLoading:
				isLoading = true
			default: break
				
			}
		}
	}

	// MARK: - Body
	var body: some View {
		notRequestedView
			.onReceive(inspection.notice) { inspection.visit(self, $0) }
			.applyNavigationBarPlainStyle(title: "ForgotPassword.Title".localized,
										  titleColor: titleColor,
										  leftBarItems: {
				BackButton(customBack)
			},
										  rightBarItems: {
				Spacer()
			})
			.progressHUD(isLoading)
			.hideKeyboardOnTapped()
			.grandientBackground()
			.alert(isPresented: $isShowError) {
				Alert(title: Text(error?.title ?? ""),
					  message: Text(error?.message ?? ""),
					  dismissButton: .default(Text(error?.primaryButtonTitle ?? "")))
			}
			.alert("ForgotPassword.CheckYourEmail".localized, isPresented: $showAlert) {
				Button("ForgotPassword.OK".localized) {
					showAlert = false
					self.customBack()
				}
			} message: {
				Text("ForgotPassword.ALinkResetYourPasswordHasBeenSentEmail".localized)
			}
	}
}

// MARK: - Loading Content
private extension FogotPasswordView {
	var notRequestedView: some View {
		FogotPasswordContentView { email in
			loadable = .isLoading(last: nil, cancelBag: CancelBag())
			Task {
				loadable = await injected.interactors.fogotPasswordInteractor.recoverPassword(email: email, customServer: customServer)
			}
		}
	}
}

// MARK: - Private variable
private extension FogotPasswordView {
	var titleColor: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.offWhite : AppTheme.shared.colorSet.grey3
	}
}

// MARK: - Private func
private extension FogotPasswordView {
	func customBack() {
		self.presentationMode.wrappedValue.dismiss()
	}
}

// MARK: - Preview
#if DEBUG
struct FogotPasswordView_Previews: PreviewProvider {
	static var previews: some View {
		FogotPasswordView(customServer: .constant(CustomServer()))
	}
}
#endif
