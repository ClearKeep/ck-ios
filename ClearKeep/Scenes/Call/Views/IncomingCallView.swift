//
//  IncomingCallView.swift
//  ClearKeep
//
//  Created by đông on 31/03/2022.
//

import SwiftUI
import Combine
import Common
import CommonUI

private enum Constant {
	static let spacerTopView = 90.0
	static let spacerBottomView = 20.0
	static let spacer = 25.0
	static let spacerBottom = 45.0
	static let paddingVertical = 14.0
	static let paddingHorizontal = 24.0
	static let heightButton = 40.0
	static let cornerRadiusButtonNext = 40.0
	static let cornerRadiusTagUser = 80.0
	static let sizeImage = 64.0
	static let paddingButtonNext = 60.0
}

struct IncomingCallView: View {
	// MARK: - Variables
	let inspection = ViewInspector<Self>()
	@Environment(\.injected) private var injected: DIContainer
	@Environment(\.colorScheme) private var colorScheme
	@Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
	@State private(set) var samples: Loadable<[ICallModel]>
	@State private(set) var isShowingView: Bool = false

	// MARK: - Init
	public init(samples: Loadable<[ICallModel]> = .notRequested) {
		self._samples = .init(initialValue: samples)
	}

	// MARK: - Body
	var body: some View {
		content
			.onReceive(inspection.notice) { inspection.visit(self, $0) }
			.edgesIgnoringSafeArea(.all)
			.navigationBarBackButtonHidden(true)
    }
}

// MARK: - Private
private extension IncomingCallView {
	var content: AnyView {
		AnyView(notRequestedView)
	}
}

// MARK: - Loading Content
private extension IncomingCallView {
	var notRequestedView: some View {
		VStack {
			buttonBackView
				.padding(.top, Constant.spacerTopView)
			Spacer()
		}
		.padding(.horizontal, Constant.paddingVertical)
	}

	var buttonBackView: some View {
				Text("Call.Calling".localized)
					.padding(.all)
					.font(AppTheme.shared.fontSet.font(style: .body1))
//					.foregroundColor(foregroundButtonBack)
			.frame(maxWidth: .infinity, alignment: .center)
	}
}
struct IncomingCallView_Previews: PreviewProvider {
    static var previews: some View {
        IncomingCallView()
    }
}
