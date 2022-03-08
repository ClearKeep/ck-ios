//
//  LoginView.swift
//  ClearKeep
//
//  Created by MinhDev on 07/03/2022.
//

import SwiftUI
import Common

struct LoginView: View {
	// MARK: - Constants
	private let inspection = ViewInspector<Self>()
	
	// MARK: - Variables
	@Environment(\.injected) private var injected: DIContainer
	
	// MARK: - Body
	var body: some View {
		content
			.onReceive(inspection.notice) { inspection.visit(self, $0) }
	}
}

// MARK: - Private
private extension LoginView {
	var content: AnyView {
		AnyView(notRequestedView)
	}
}

// MARK: - Loading Content
private extension LoginView {
	var notRequestedView: some View {
		NavigationView {
			NavigationLink(destination: FogotPasswordView(email: "", password: "", rePassword: "", emailStyle: .normal, passwordStyle: .normal, rePasswordStyle: .normal)) {
				Text("sadsd")
			}
		}
	}
}

// MARK: - Interactor
private extension LoginView {
}

// MARK: - Preview
#if DEBUG
struct LoginView_Previews: PreviewProvider {
	static var previews: some View {
		LoginView()
	}
}
#endif
