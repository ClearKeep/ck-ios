//
//  ChangePasswordView.swift
//  ClearKeep
//
//  Created by MinhDev on 22/03/2022.
//

import SwiftUI
import Common

struct ChangePasswordView: View {
	// MARK: - Constants
	private let inspection = ViewInspector<Self>()
	
	// MARK: - Variables
	@Environment(\.injected) private var injected: DIContainer
	
	// MARK: - Body
	var body: some View {
		content
		.onReceive(inspection.notice) { inspection.visit(self, $0) }
		.navigationBarTitle("")
		.navigationBarHidden(true)
	}
}

// MARK: - Private
private extension ChangePasswordView {
	var content: AnyView {
		AnyView(notRequestedView)
	}
}

// MARK: - Loading Content
private extension ChangePasswordView {
	var notRequestedView: some View {
		ChangePasswordContentView()
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
