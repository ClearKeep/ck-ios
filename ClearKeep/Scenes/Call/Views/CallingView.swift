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
import _NIODataStructures

private enum Constant {
	static let spacerTopView = 90.0
	static let spacer = 25.0
	static let spacerBottom = 45.0
	static let paddingVertical = 14.0
	static let sizeImage = 140.0
	static let sizeIcon = 64.0
	static let borderLineWidth = 2.0
	static let opacity = 0.8
}

struct CallingView: View {
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

	// MARK: - Init
	public init(samples: Loadable<[ICallModel]> = .notRequested) {
		self._samples = .init(initialValue: samples)
	}

	// MARK: - Body
	var body: some View {
		content
			.onReceive(inspection.notice) { inspection.visit(self, $0) }
			.background(AppTheme.shared.colorSet.warningDefault.opacity(Constant.opacity))
			.edgesIgnoringSafeArea(.all)
			.navigationBarBackButtonHidden(true)
	}
}

// MARK: - Private
private extension CallingView {
	var content: AnyView {
		AnyView(contentView)
	}
}

// MARK: - Loading Content
private extension CallingView {
	var contentView: some View {
		VStack(spacing: Constant.spacer) {
			statusCalling
				.padding(.top, Constant.spacerTopView)
			userPicture
			userName
			supportCalling
				.padding(.top, Constant.spacerBottom)
			buttonCancel
				.padding(.bottom, Constant.sizeIcon)
			Spacer()
		}
		.padding(.horizontal, Constant.paddingVertical)
	}

	var statusCalling: some View {
		Text("Call.Calling".localized)
			.padding(.all)
			.font(AppTheme.shared.fontSet.font(style: .input2))
			.foregroundColor(AppTheme.shared.colorSet.grey5)
			.frame(maxWidth: .infinity, alignment: .center)
	}

	var userPicture: some View {
		ZStack {
			Circle()
				.fill(backgroundGradientPrimary)
				.frame(width: Constant.sizeImage, height: Constant.sizeImage)
			AppTheme.shared.imageSet.userIcon
		}
	}

	var userName: some View {
		Text("Alex".localized)
			.frame(maxWidth: .infinity, alignment: .center)
			.font(AppTheme.shared.fontSet.font(style: .display2))
			.foregroundColor(AppTheme.shared.colorSet.offWhite)
	}

	var supportCalling: some View {
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
	}

	var buttonCancel: some View {
		VStack {
			Button {
				isTappedEndCall.toggle()
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
			Text("Call.Cancel".localized)
				.font(AppTheme.shared.fontSet.font(style: .body2))
				.foregroundColor(AppTheme.shared.colorSet.offWhite)
		}
	}
}

// MARK: - Color func
private extension CallingView {
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

struct CallingView_Previews: PreviewProvider {
	static var previews: some View {
		CallingView()
	}
}
