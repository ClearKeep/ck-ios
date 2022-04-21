//
//  NewPasswordView.swift
//  ClearKeep
//
//  Created by MinhDev on 22/03/2022.
//

import SwiftUI
import Common
import CommonUI

struct NewPasswordView: View {
	// MARK: - Constants
	private let inspection = ViewInspector<Self>()
	
	// MARK: - Variables
	@Environment(\.injected) private var injected: DIContainer

	// MARK: - Body
	var body: some View {
		content
		.onReceive(inspection.notice) { inspection.visit(self, $0) }
		.modifier(NavigationModifier())
	}
}

// MARK: - Private
private extension NewPasswordView {
	var content: AnyView {
		AnyView(notRequestedView)
	}
}

// MARK: - Loading Content
private extension NewPasswordView {
	var notRequestedView: some View {
		NewPasswordContenView()
	}
}

// MARK: - Interactor
private extension NewPasswordView {
}
	
// MARK: - Preview
#if DEBUG
struct NewPasswordView_Previews: PreviewProvider {
	static var previews: some View {
		NewPasswordView()
	}
}
#endif
