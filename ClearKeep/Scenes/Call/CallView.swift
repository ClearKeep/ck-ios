//
//  CallView.swift
//  ClearKeep
//
//  Created by đông on 09/05/2022.
//

import SwiftUI
import Common

struct CallView: View {
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
private extension CallView {
	var content: AnyView {
		AnyView(notRequestedView)
	}
}

// MARK: - Loading Content
private extension CallView {
	var notRequestedView: some View {
		Text("")
	}
}

// MARK: - Interactor
private extension CallView {
}
	
// MARK: - Preview
#if DEBUG
struct CallView_Previews: PreviewProvider {
	static var previews: some View {
		CallView()
	}
}
#endif
