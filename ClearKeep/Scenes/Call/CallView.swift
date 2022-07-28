//
//  CallView.swift
//  ClearKeep
//
//  Created by đông on 09/05/2022.
//

import SwiftUI
import Common
import ChatSecure

struct CallView: View {
	// MARK: - Constants
	private let inspection = ViewInspector<Self>()
	
	// MARK: - Variables
	@Environment(\.injected) private var injected: DIContainer
	
	private let groupId: Int64
	@ObservedObject var viewModel: CallViewModel
	
	init(groupId: Int64) {
		self.groupId = groupId
		self.viewModel = CallViewModel()
	}

	// MARK: - Body
	var body: some View {
		content
			.onAppear {
				Task {
					await injected.interactors.callInteractor.requestCall(groupId: groupId, isAudioCall: true)
					if let callBox = CallManager.shared.calls.first {
						viewModel.updateCallBox(callBox: callBox)
					}
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
		CallingView(viewModel: viewModel)
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
