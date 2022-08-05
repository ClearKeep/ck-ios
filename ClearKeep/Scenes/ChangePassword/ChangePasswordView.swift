//
//  ChangePasswordView.swift
//  ClearKeep
//
//  Created by MinhDev on 22/03/2022.
//

import SwiftUI
import Common
import CommonUI

struct ChangePasswordView: View {
	// MARK: - Constants
	private let inspection = ViewInspector<Self>()
	
	// MARK: - Variables
	@Environment(\.injected) private var injected: DIContainer
	@State private var loadable: Loadable<Bool> = .notRequested
	
	// MARK: - Body
	var body: some View {
		content
			.onReceive(inspection.notice) { inspection.visit(self, $0) }
			.hideKeyboardOnTapped()
			.hiddenNavigationBarStyle()
	}
}

// MARK: - Private
private extension ChangePasswordView {
	var content: AnyView {
		switch loadable {
		case .notRequested:
			return AnyView(notRequestedView)
		case .isLoading:
			return AnyView(loadingView)
		case .loaded(let data):
			return loadedView(value: data)
		case .failed(let error):
			return AnyView(errorView(ChangePasswordErrorView(error)))
		}
	}
}

// MARK: - Loading Content
private extension ChangePasswordView {
	var notRequestedView: some View {
		ChangePasswordContentView(loadable: $loadable)
	}
	
	var loadingView: some View {
		notRequestedView.progressHUD(true)
	}
	
	func loadedView(value: Bool) -> AnyView {
		return AnyView(notRequestedView)
	}
	
	func errorView(_ error: ChangePasswordErrorView) -> some View {
		return notRequestedView
			.alert(isPresented: .constant(true)) {
				Alert(title: Text(error.title),
					  message: Text(error.message),
					  dismissButton: .default(Text(error.primaryButtonTitle)))
			}
	}
}

// MARK: - Interactor
private extension ChangePasswordView {
}

// MARK: - Preview
#if DEBUG
struct ChangePasswordView_Previews: PreviewProvider {
	static var previews: some View {
		ChangePasswordView()
	}
}
#endif
