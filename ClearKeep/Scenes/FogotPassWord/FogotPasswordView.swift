//
//  FogotPasswordView.swift
//  ClearKeep
//
//  Created by MinhDev on 22/03/2022.
//

import SwiftUI
import Common
import CommonUI

struct FogotPasswordView: View {
	// MARK: - Constants
	private let inspection = ViewInspector<Self>()
	
	// MARK: - Variables
	@Environment(\.injected) private var injected: DIContainer
	
	// MARK: - Body
	var body: some View {
		content
		.hideKeyboardOnTapped()
		.onReceive(inspection.notice) { inspection.visit(self, $0) }
		.modifier(NavigationModifier())
	}
}

// MARK: - Private
private extension FogotPasswordView {
	var content: AnyView {
		AnyView(notRequestedView)
	}
}

// MARK: - Loading Content
private extension FogotPasswordView {
	var notRequestedView: some View {
		FogotPasswordContentView(emailStyle: .default)
	}
}

// MARK: - Interactor
private extension FogotPasswordView {
}
	
// MARK: - Preview
#if DEBUG
struct FogotPasswordView_Previews: PreviewProvider {
	static var previews: some View {
		FogotPasswordView()
	}
}
#endif
