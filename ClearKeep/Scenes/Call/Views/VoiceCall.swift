//
//  VoiceCall.swift
//  ClearKeep
//
//  Created by đông on 04/04/2022.
//

import SwiftUI
import Combine
import Common
import CommonUI
import _NIODataStructures

private enum Constant {
	static let spacerTopView = 90.0
	static let spacer = 25.0
	static let spacerBottom = 45.0
	static let paddingVertical = 14.0
	static let sizeImage = 120.0
	static let sizeIcon = 64.0
	static let borderLineWidth = 2.0
	static let opacity = 0.8
}

struct VoiceCall: View {
	// MARK: - Variables
	let inspection = ViewInspector<Self>()
	@Environment(\.injected) private var injected: DIContainer
	@Environment(\.colorScheme) private var colorScheme
	@Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
	@State private(set) var samples: Loadable<[ICallModel]>
	@State private(set) var isTappedMute: Bool = false
	@State private(set) var isTappedCamera: Bool = false
	@State private(set) var isTappedSpeaker: Bool = false
	@State private(set) var isTappedEndCall: Bool = false
	@State private var timeCalled = 1

	let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

	// MARK: - Init
	public init(samples: Loadable<[ICallModel]> = .notRequested) {
		self._samples = .init(initialValue: samples)
	}

	// MARK: - Body
	var body: some View {
		VStack(spacing: Constant.spacer) {
			Button(action: customBack) {
				HStack(spacing: Constant.spacer) {
					AppTheme.shared.imageSet.chevleftIcon
						.aspectRatio(contentMode: .fit)
						.foregroundColor(foregroundBackButton)
				}
				.frame(maxWidth: .infinity, alignment: .leading)
				.foregroundColor(AppTheme.shared.colorSet.offWhite)
			}

				.padding(.top, Constant.spacerTopView)

			ZStack {
				Circle()
					.fill(backgroundGradientPrimary)
					.frame(width: Constant.sizeImage, height: Constant.sizeImage)
				AppTheme.shared.imageSet.userIcon
			}

			Text("Alex".localized)
				.frame(maxWidth: .infinity, alignment: .center)
				.font(AppTheme.shared.fontSet.font(style: .display2))
				.foregroundColor(AppTheme.shared.colorSet.offWhite)
			timeCalling

			HStack {
				VStack {
					ImageButtonCall(image: muteIcon, isChecked: $isTappedMute)
					Text("Call.Mute".localized)
						.font(AppTheme.shared.fontSet.font(style: .body2))
						.foregroundColor(AppTheme.shared.colorSet.offWhite)
				}
				.frame(maxWidth: .infinity)

				VStack {
					ImageButtonCall(image: cameraIcon, isChecked: $isTappedCamera)
					Text("Call.Camera".localized)
						.font(AppTheme.shared.fontSet.font(style: .body2))
						.foregroundColor(AppTheme.shared.colorSet.offWhite)
				}
				.frame(maxWidth: .infinity)

				VStack {
					ImageButtonCall(image: speakerIcon, isChecked: $isTappedSpeaker)
					Text("Call.Speaker".localized)
						.font(AppTheme.shared.fontSet.font(style: .body2))
						.foregroundColor(AppTheme.shared.colorSet.offWhite)
				}
				.frame(maxWidth: .infinity)
			}
			.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
				.padding(.top, Constant.spacerBottom)

			VStack {
				Button {
					timeCalled = 0
				} label: {
					ZStack {
						Circle()
							.strokeBorder(AppTheme.shared.colorSet.errorDefault, lineWidth: Constant.borderLineWidth)
							.background(Circle().foregroundColor(AppTheme.shared.colorSet.errorDefault))
							.frame(width: Constant.sizeIcon, height: Constant.sizeIcon)
						AppTheme.shared.imageSet.phoneOffIcon
							.foregroundColor(AppTheme.shared.colorSet.offWhite)
					}
			}
				Text("Call.End".localized)
					.font(AppTheme.shared.fontSet.font(style: .body2))
					.foregroundColor(AppTheme.shared.colorSet.offWhite)
			}
				.padding(.bottom, Constant.sizeIcon)
			Spacer()
		}
		.padding(.horizontal, Constant.paddingVertical)
			.onReceive(inspection.notice) { inspection.visit(self, $0) }
			.background(AppTheme.shared.colorSet.warningDefault.opacity(Constant.opacity))
			.edgesIgnoringSafeArea(.all)
			.navigationBarBackButtonHidden(true)
	}
}

// MARK: - Private
private extension VoiceCall {
	var timeCalling: some View {
		Text(getTimer())
			.foregroundColor(AppTheme.shared.colorSet.offWhite)
			.onReceive(timer) { _ in
				if timeCalled > 0 {
					timeCalled += 1
				}
			}
	}
}

// MARK: - Loading Content
private extension VoiceCall {
	
}

// MARK: - Color func
private extension VoiceCall {
	var foregroundBackButton: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.offWhite : AppTheme.shared.colorSet.greyLight
	}

	var backgroundGradientPrimary: LinearGradient {
		LinearGradient(gradient: Gradient(colors: AppTheme.shared.colorSet.gradientPrimary), startPoint: .leading, endPoint: .trailing)
	}

	var muteIcon: Image {
		isTappedMute ? AppTheme.shared.imageSet.muteOffIcon : AppTheme.shared.imageSet.muteIcon
	}

	var cameraIcon: Image {
		isTappedCamera ? AppTheme.shared.imageSet.cameraOffIcon : AppTheme.shared.imageSet.cameraIcon
	}

	var speakerIcon: Image {
		isTappedSpeaker ? AppTheme.shared.imageSet.speakerOffIcon2 : AppTheme.shared.imageSet.speakerIcon2
	}
}

// MARK: - Private Func
private extension VoiceCall {
	func customBack() {
		self.presentationMode.wrappedValue.dismiss()
	}

	func getTimer() -> String {
		let minutes = Int(timeCalled) / 60 % 60
		let seconds = Int(timeCalled) % 60
		return String(format: "%02i:%02i", minutes, seconds)
	}
}

struct VoiceCall_Previews: PreviewProvider {
	static var previews: some View {
		VoiceCall()
	}
}
