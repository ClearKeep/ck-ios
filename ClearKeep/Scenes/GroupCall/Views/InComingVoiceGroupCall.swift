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
	static let spacerBottomView = 20.0
	static let spacer = 25.0
	static let spacerBottom = 45.0
	static let paddingVertical = 14.0
	static let paddingHorizontal = 24.0
	static let heightButton = 40.0
	static let cornerRadiusButtonNext = 40.0
	static let cornerRadiusTagUser = 80.0
	static let sizeImage = 120.0
	static let paddingButtonNext = 60.0
	static let borderLineWidth = 2.0
	static let opacity = 0.2
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
			.background(backgroundGradientPrimary)
			.edgesIgnoringSafeArea(.all)
			.navigationBarBackButtonHidden(true)
	}
}

// MARK: - Private
private extension InComingVoiceGroupCall {
	var content: AnyView {
		AnyView(notRequestedView)
	}
}

// MARK: - Loading Content
private extension InComingVoiceGroupCall {
	var notRequestedView: some View {
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
			.foregroundColor(foregroundColorGrey5)
			.frame(maxWidth: .infinity, alignment: .center)
	}

	var userName: some View {
		Text("UI Designs".localized)
			.frame(maxWidth: .infinity, alignment: .center)
			.font(AppTheme.shared.fontSet.font(style: .display2))
			.foregroundColor(foregroundColorWhite)
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
							.strokeBorder(backgroundDecline, lineWidth: Constant.borderLineWidth)
							.background(Circle().foregroundColor(backgroundDecline))
							.frame(width: Constant.paddingButtonNext, height: Constant.paddingButtonNext)
						AppTheme.shared.imageSet.phoneOffIcon
							.renderingMode(.template)
							.foregroundColor(foregroundColorWhite)
					}
			}
				Text("Call.Decline".localized)
					.font(AppTheme.shared.fontSet.font(style: .body2))
					.foregroundColor(foregroundColorWhite)
			}
			.frame(maxWidth: .infinity)

			VStack {
				Button {
					isTappedAnswer.toggle()
				} label: {
					ZStack {
						Circle()
							.strokeBorder(backgroundAnswer, lineWidth: Constant.borderLineWidth)
							.background(Circle().foregroundColor(backgroundAnswer))
							.frame(width: Constant.paddingButtonNext, height: Constant.paddingButtonNext)
						AppTheme.shared.imageSet.phoneCallIcon
							.renderingMode(.template)
							.foregroundColor(foregroundColorWhite)
					}
			}
				Text("Call.Decline".localized)
					.font(AppTheme.shared.fontSet.font(style: .body2))
					.foregroundColor(foregroundColorWhite)
			}
			.frame(maxWidth: .infinity)
		}
		.frame(maxWidth: .infinity)
	}
}

// MARK: - Color func
private extension InComingVoiceGroupCall {
	var foregroundColorWhite: Color {
		AppTheme.shared.colorSet.offWhite
	}

	var foregroundColorBlack: Color {
		AppTheme.shared.colorSet.black
	}

	var foregroundColorPrimary: Color {
		AppTheme.shared.colorSet.primaryDefault
	}

	var foregroundColorGrey5: Color {
		AppTheme.shared.colorSet.grey5
	}

	var foregroundColorGreyLight: Color {
		AppTheme.shared.colorSet.greyLight
	}

	var foregroundCrossIcon: Color {
		colorScheme == .light ? foregroundColorBlack : foregroundColorGreyLight
	}

	var backgroundGradientPrimary: LinearGradient {
		LinearGradient(gradient: Gradient(colors: AppTheme.shared.colorSet.gradientPrimary), startPoint: .leading, endPoint: .trailing)
	}

	var backgroundDecline: Color {
		AppTheme.shared.colorSet.errorDefault
	}

	var backgroundAnswer: Color {
		AppTheme.shared.colorSet.successDefault
	}
}
struct InComingVoiceGroupCall_Previews: PreviewProvider {
	static var previews: some View {
        InComingVoiceGroupCall()
    }
}
