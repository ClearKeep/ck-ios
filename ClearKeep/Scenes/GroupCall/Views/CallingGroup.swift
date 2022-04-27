//
//  CallingGroup.swift
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
	static let spacerBottom = 45.0
	static let paddingVertical = 14.0
	static let paddingButtonNext = 60.0
	static let borderLineWidth = 2.0
}

struct CallingGroup: View {
	// MARK: - Variables
	let inspection = ViewInspector<Self>()
	@Environment(\.injected) private var injected: DIContainer
	@Environment(\.colorScheme) private var colorScheme
	@Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
	@State private(set) var samples: Loadable<[IGroupCallModel]>
	@State private(set) var isTappedMute: Bool = false
	@State private(set) var isTappedCamera: Bool = false
	@State private(set) var isTappedSpeaker: Bool = false
	@State private(set) var isTappedCancel: Bool = false

	// MARK: - Init
	public init(samples: Loadable<[IGroupCallModel]> = .notRequested) {
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
private extension CallingGroup {
	var content: AnyView {
		AnyView(contentView)
	}
}

// MARK: - Loading Content
private extension CallingGroup {
	var contentView: some View {
		VStack(spacing: Constant.spacer) {
			statusCalling
				.padding(.top, Constant.spacerTopView)
			userName
			supportCalling
				.padding(.top, Constant.spacerBottom)
			buttonCancel
				.padding(.bottom, Constant.paddingButtonNext)
			Spacer()
		}
		.padding(.horizontal, Constant.paddingVertical)
	}

	var statusCalling: some View {
		Text("CallGroup.Calling".localized)
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
	}

	var supportCalling: some View {
		HStack {
			Button {
				isTappedMute.toggle()
			} label: {
				ZStack {
					Circle()
						.strokeBorder(AppTheme.shared.colorSet.offWhite, lineWidth: Constant.borderLineWidth)
						.background(Circle().foregroundColor(backgroundButtonMute))
						.frame(width: Constant.paddingButtonNext, height: Constant.paddingButtonNext)
					muteIcon
						.foregroundColor(foregroundButtonMute)
				}
				.frame(maxWidth: .infinity)
			}

			Button {
				isTappedCamera.toggle()
			} label: {
				ZStack {
					Circle()
						.strokeBorder(AppTheme.shared.colorSet.offWhite, lineWidth: Constant.borderLineWidth)
						.background(Circle().foregroundColor(backgroundButtonCamera))
						.frame(width: Constant.paddingButtonNext, height: Constant.paddingButtonNext)
					cameraIcon
						.foregroundColor(foregroundButtonCamera)
				}
				.frame(maxWidth: .infinity)
			}

			Button {
				isTappedSpeaker.toggle()
			} label: {
				ZStack {
					Circle()
						.strokeBorder(AppTheme.shared.colorSet.offWhite, lineWidth: Constant.borderLineWidth)
						.background(Circle().foregroundColor(backgroundButtonSpeaker))
						.frame(width: Constant.paddingButtonNext, height: Constant.paddingButtonNext)
					speakerIcon
						.foregroundColor(foregroundButtonSpeaker)
				}
			}
			.frame(maxWidth: .infinity)
		}
		.frame(maxWidth: .infinity, alignment: .top)
		.frame(minHeight: 0, maxHeight: .infinity)
	}

	var buttonCancel: some View {
		VStack {
			Button {
				isTappedCancel.toggle()
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
			Text("Call.Cancel".localized)
				.font(AppTheme.shared.fontSet.font(style: .body2))
				.foregroundColor(AppTheme.shared.colorSet.offWhite)
		}
	}
}

// MARK: - Color func
private extension CallingGroup {
	var backgroundGradientPrimary: LinearGradient {
		LinearGradient(gradient: Gradient(colors: AppTheme.shared.colorSet.gradientPrimary), startPoint: .leading, endPoint: .trailing)
	}

	var backgroundDarkGrey2: LinearGradient {
		LinearGradient(gradient: Gradient(colors: [AppTheme.shared.colorSet.darkGrey2, AppTheme.shared.colorSet.darkGrey2]), startPoint: .leading, endPoint: .trailing)
	}

	var background: LinearGradient {
		colorScheme == .light ? backgroundGradientPrimary : backgroundDarkGrey2
	}

	var backgroundButtonMute: Color {
		isTappedMute ? AppTheme.shared.colorSet.offWhite : AppTheme.shared.colorSet.offWhite.opacity(0)
	}

	var foregroundButtonMute: Color {
		isTappedMute ? AppTheme.shared.colorSet.black : AppTheme.shared.colorSet.offWhite
	}

	var backgroundButtonCamera: Color {
		isTappedCamera ? AppTheme.shared.colorSet.offWhite : AppTheme.shared.colorSet.offWhite.opacity(0)
	}

	var foregroundButtonCamera: Color {
		isTappedCamera ? AppTheme.shared.colorSet.black : AppTheme.shared.colorSet.offWhite
	}

	var backgroundButtonSpeaker: Color {
		isTappedSpeaker ? AppTheme.shared.colorSet.offWhite : AppTheme.shared.colorSet.offWhite.opacity(0)
	}

	var foregroundButtonSpeaker: Color {
		isTappedSpeaker ? AppTheme.shared.colorSet.black : AppTheme.shared.colorSet.offWhite
	}

	var muteIcon: Image {
		isTappedMute ? AppTheme.shared.imageSet.microphoneOffIcon : AppTheme.shared.imageSet.microPhoneIcon
	}

	var cameraIcon: Image {
		isTappedCamera ? AppTheme.shared.imageSet.videoOffIcon : AppTheme.shared.imageSet.videoIcon
	}

	var speakerIcon: Image {
		isTappedSpeaker ? AppTheme.shared.imageSet.speakerOffIcon : AppTheme.shared.imageSet.speakerIcon
	}
}

struct CallingGroup_Previews: PreviewProvider {
	static var previews: some View {
		CallingGroup()
	}
}
