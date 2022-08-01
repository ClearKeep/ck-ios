//
//  TwoFactorView.swift
//  ClearKeep
//
//  Created by đông on 04/04/2022.
//

import SwiftUI
import Common
import CommonUI

enum TwoFactorType {
	case login, setting
}

struct TwoFactorView: View {
	// MARK: - Constants
	private let inspection = ViewInspector<Self>()

	// MARK: - Variables
	@Environment(\.injected) private var injected: DIContainer
	@State private var loadable: Loadable<Bool> = .notRequested
	@State private(set) var otp: String = ""
	private(set) var otpHash: String = ""
	private(set) var userId: String = ""
	private(set) var domain: String = ""
	private(set) var password: String = ""
	let twoFactorType: TwoFactorType

	// MARK: - Body
	var body: some View {
		content
			.onReceive(inspection.notice) { inspection.visit(self, $0) }
	}
}

// MARK: - Private
private extension TwoFactorView {
	var content: AnyView {
		switch loadable {
		case .notRequested:
			return AnyView(notRequestedView)
		case .isLoading:
			return AnyView(loadingView)
		case .loaded(let data):
			return loadedView(value: data)
		case .failed(let error):
			return AnyView(errorView(TwoFactorErrorView(error)))
		}
	}
}

// MARK: - Loading Content
private extension TwoFactorView {
	var notRequestedView: AnyView {
		if twoFactorType == .login {
			return AnyView(TwoFactorContentView(loadable: $loadable, otpHash: otpHash, userId: userId, domain: domain, password: password, twoFactorType: twoFactorType))
		} else {
			return AnyView(CurrentPasswordView(loadable: $loadable))
		}
	}
	
	var loadingView: some View {
		notRequestedView.progressHUD(true)
	}
	
	func loadedView(value: Bool) -> AnyView {
		return AnyView(TwoFactorContentView(loadable: $loadable, twoFactorType: twoFactorType))
	}
	
	func errorView(_ error: TwoFactorErrorView) -> some View {
		return notRequestedView
			.alert(isPresented: .constant(true)) {
				Alert(title: Text(error.title),
					  message: Text(error.message),
					  dismissButton: .default(Text(error.primaryButtonTitle)))
			}
	}
}

// MARK: - Interactor
private extension TwoFactorView {
	
}

// MARK: - Preview
#if DEBUG
struct TwoFactorView_Previews: PreviewProvider {
	static var previews: some View {
		TwoFactorView(twoFactorType: .setting)
	}
}
#endif
