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
	@State private(set) var loadable: Loadable<Bool> = .notRequested
	
	// MARK: - Body
	var body: some View {
		content
			.onReceive(inspection.notice) { inspection.visit(self, $0) }
			.applyNavigationBarPlainStyle(title: "ForgotPassword.Title".localized,
										  titleColor: titleColor,
										  leftBarItems: {
				BackButton(customBack)
			},
										  rightBarItems: {
				Spacer()
			})
			.hideKeyboardOnTapped()
			.grandientBackground()
	}
}

// MARK: - Private
private extension FogotPasswordView {
	var content: AnyView {
		switch loadable {
		case .notRequested:
			return AnyView(notRequestedView)
		case .isLoading:
			return AnyView(loadingView)
		case .loaded:
			return AnyView(loadedView)
		case .failed(let error):
			return AnyView(errorView(RegisterViewError(error)))
		}
	}
}

// MARK: - Loading Content
private extension FogotPasswordView {
	var notRequestedView: some View {
		FogotPasswordContentView(loadable: $loadable, customServer: $customServer)
	}
	
	var loadingView: some View {
		notRequestedView.progressHUD(true)
	}
	
	var loadedView: some View {
		return notRequestedView
			.alert(isPresented: .constant(true)) {
				Alert(title: Text("Register.Success.Title".localized),
					  message: Text("Register.Success.Message".localized),
					  dismissButton: .default(Text("General.OK".localized), action: {
					presentationMode.wrappedValue.dismiss()
				}))
			}
	}
	
	func errorView(_ error: RegisterViewError) -> some View {
		return notRequestedView
			.alert(isPresented: .constant(true)) {
				Alert(title: Text(error.title),
					  message: Text(error.message),
					  dismissButton: .default(Text(error.primaryButtonTitle)))
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
