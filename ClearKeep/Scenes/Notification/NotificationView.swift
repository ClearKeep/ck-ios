//
//  NotificationView.swift
//  ClearKeep
//
//  Created by đông on 04/04/2022.
//

import SwiftUI
import Common

struct NotificationView: View {
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
private extension NotificationView {
	var content: AnyView {
		AnyView(notRequestedView)
	}
}

// MARK: - Loading Content
private extension NotificationView {
	var notRequestedView: some View {
		NotificationContentView()
	}
}

// MARK: - Interactor
private extension NotificationView {
}
	
// MARK: - Preview
#if DEBUG
struct NotificationView_Previews: PreviewProvider {
	static var previews: some View {
		NotificationView()
	}
}
#endif
