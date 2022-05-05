//
//  GroupCallView.swift
//  ClearKeep
//
//  Created by đông on 07/04/2022.
//

import SwiftUI
import Common

struct GroupCallView: View {
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
private extension GroupCallView {
	var content: AnyView {
		AnyView(contentView)
	}
}

// MARK: - Loading Content
private extension GroupCallView {
	var contentView: some View {
		CallingGroup()
	}
}

// MARK: - Interactor
private extension GroupCallView {
}
	
// MARK: - Preview
#if DEBUG
struct GroupCallView_Previews: PreviewProvider {
	static var previews: some View {
		GroupCallView()
	}
}
#endif
