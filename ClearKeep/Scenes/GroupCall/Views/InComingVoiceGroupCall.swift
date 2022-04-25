//
//  InComingVoiceGroupCall.swift
//  ClearKeep
//
//  Created by đông on 08/04/2022.
//

import SwiftUI
import Combine
import Common
import CommonUI

private enum Constant {
	static let spacerTopView = 90.0
	static let spacer = 25.0
	static let paddingVertical = 14.0
	static let paddingButtonNext = 60.0
	static let borderLineWidth = 2.0
}

struct InComingVoiceGroupCall: View {
	// MARK: - Variables
	let inspection = ViewInspector<Self>()
	@Environment(\.injected) private var injected: DIContainer
	@Environment(\.colorScheme) private var colorScheme
	@Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
	@State private(set) var samples: Loadable<[ICallModel]>
	@State private(set) var isTappedDecline: Bool = false
	@State private(set) var isTappedAnswer: Bool = false

	// MARK: - Init
	public init(samples: Loadable<[ICallModel]> = .notRequested) {
		self._samples = .init(initialValue: samples)
	}

	// MARK: - Body
	var body: some View {
		content
			.onReceive(inspection.notice) { inspection.visit(self, $0) }
			.background(background)
			.edgesIgnoringSafeArea(.all)
			.navigationBarBackButtonHidden(true)
	}
}

// MARK: - Private
private extension InComingVoiceGroupCall {
	var content: AnyView {
		AnyView(contentView)
	}
}

// MARK: - Loading Content
private extension InComingVoiceGroupCall {
	var contentView: some View {
		VStack(spacing: Constant.spacer) {
			statusCalling
				.padding(.top, Constant.spacerTopView)
			userName
			buttonResponse
				.padding(.bottom, Constant.paddingButtonNext)
			Spacer()
		}
		.padding(.horizontal, Constant.paddingVertical)
	}

	var statusCalling: some View {
		Text("CallGroup.Incomming.Voice".localized)
			.padding(.all)
			.font(AppTheme.shared.fontSet.font(style: .input2))
			.foregroundColor(AppTheme.shared.colorSet.grey5)
			.frame(maxWidth: .infinity, alignment: .center)
	}

	var userName: some View {
		Text("UI Designs".localized)
			.frame(maxWidth: .infinity, alignment: .center)
			.font(AppTheme.shared.fontSet.font(style: .display2))
			.foregroundColor(AppTheme.shared.colorSet.offWhite)
			.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
	}

	var buttonResponse: some View {
		HStack {
			VStack {
				Button {
					isTappedDecline.toggle()
				} label: {
					ZStack {
						Circle()
							.strokeBorder(AppTheme.shared.colorSet.errorDefault, lineWidth: Constant.borderLineWidth)
							.background(Circle().foregroundColor(AppTheme.shared.colorSet.errorDefault))
							.frame(width: Constant.paddingButtonNext, height: Constant.paddingButtonNext)
						AppTheme.shared.imageSet.phoneOffIcon
							.foregroundColor(AppTheme.shared.colorSet.offWhite)
					}
			}
				Text("Call.Decline".localized)
					.font(AppTheme.shared.fontSet.font(style: .body2))
					.foregroundColor(AppTheme.shared.colorSet.offWhite)
			}
			.frame(maxWidth: .infinity)

			VStack {
				Button {
					isTappedAnswer.toggle()
				} label: {
					ZStack {
						Circle()
							.strokeBorder(AppTheme.shared.colorSet.successDefault, lineWidth: Constant.borderLineWidth)
							.background(Circle().foregroundColor(AppTheme.shared.colorSet.successDefault))
							.frame(width: Constant.paddingButtonNext, height: Constant.paddingButtonNext)
						AppTheme.shared.imageSet.phoneCallIcon
							.foregroundColor(AppTheme.shared.colorSet.offWhite)
					}
			}
				Text("Call.Decline".localized)
					.font(AppTheme.shared.fontSet.font(style: .body2))
					.foregroundColor(AppTheme.shared.colorSet.offWhite)
			}
			.frame(maxWidth: .infinity)
		}
		.frame(maxWidth: .infinity)
	}
}

// MARK: - Color func
private extension InComingVoiceGroupCall {
	var backgroundGradientPrimary: LinearGradient {
		LinearGradient(gradient: Gradient(colors: AppTheme.shared.colorSet.gradientPrimary), startPoint: .leading, endPoint: .trailing)
	}

	var backgroundDarkGrey2: LinearGradient {
		LinearGradient(gradient: Gradient(colors: [AppTheme.shared.colorSet.darkGrey2, AppTheme.shared.colorSet.darkGrey2]), startPoint: .leading, endPoint: .trailing)
	}

	var background: LinearGradient {
		colorScheme == .light ? backgroundGradientPrimary : backgroundDarkGrey2
	}
}
struct InComingVoiceGroupCall_Previews: PreviewProvider {
	static var previews: some View {
		InComingVoiceGroupCall()
	}
}
