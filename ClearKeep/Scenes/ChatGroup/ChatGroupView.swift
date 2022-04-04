//
//  ChatGroupView.swift
//  ClearKeep
//
//  Created by đông on 04/04/2022.
//

import SwiftUI
import Common

struct ChatGroupView: View {
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
private extension ChatGroupView {
	var content: AnyView {
		AnyView(notRequestedView)
	}
}

// MARK: - Loading Content
private extension ChatGroupView {
	var notRequestedView: some View {
		ChatGroupContentView()
	}
}

// MARK: - Interactor
private extension ChatGroupView {
}
	
// MARK: - Preview
#if DEBUG
struct ChatGroupView_Previews: PreviewProvider {
	static var previews: some View {
		ChatGroupView()
	}
}
#endif
