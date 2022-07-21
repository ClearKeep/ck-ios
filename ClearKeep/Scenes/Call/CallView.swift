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
	
	private let groupId: Int64
	
	init(groupId: Int64) {
		self.groupId = groupId
	}

	// MARK: - Body
	var body: some View {
		content
			.onAppear {
				Task {
					await injected.interactors.callInteractor.requestCall(groupId: groupId, isAudioCall: true)
				}
			}
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
		CallingView()
	}
}

// MARK: - Interactor
private extension CallView {
}
	
// MARK: - Preview
#if DEBUG
struct CallView_Previews: PreviewProvider {
	static var previews: some View {
		CallView(groupId: 0)
	}
}
#endif
