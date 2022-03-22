//
//  AdvanverSeverView.swift
//  ClearKeep
//
//  Created by MinhDev on 22/03/2022.
//

import SwiftUI
import Common

struct AdvanverSeverView: View {
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
private extension AdvanverSeverView {
	var content: AnyView {
		AnyView(notRequestedView)
	}
}

// MARK: - Loading Content
private extension AdvanverSeverView {
	var notRequestedView: some View {
		AdvancerContentView(severUrl: "", severUrlStyle: (.default))
	}
}

// MARK: - Interactor
private extension AdvanverSeverView {
}
	
// MARK: - Preview
#if DEBUG
struct AdvanverSeverView_Previews: PreviewProvider {
	static var previews: some View {
		AdvanverSeverView()
	}
}
#endif
