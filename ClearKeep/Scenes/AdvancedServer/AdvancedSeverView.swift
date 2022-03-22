//
//  AdvancedSeverView.swift
//  ClearKeep
//
//  Created by MinhDev on 22/03/2022.
//

import SwiftUI
import Common

struct AdvancedSeverView: View {
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
private extension AdvancedSeverView {
	var content: AnyView {
		AnyView(notRequestedView)
	}
}

// MARK: - Loading Content
private extension AdvancedSeverView {
	var notRequestedView: some View {
		AdvancedContentView(severUrl: "", severUrlStyle: (.default))
	}
}

// MARK: - Interactor
private extension AdvancedSeverView {
}
	
// MARK: - Preview
#if DEBUG
struct AdvancedSeverView_Previews: PreviewProvider {
	static var previews: some View {
		AdvancedSeverView()
	}
}
#endif
