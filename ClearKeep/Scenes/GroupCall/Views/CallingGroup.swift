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
import _NIODataStructures

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
		VStack(spacing: Constant.spacer) {
			Text("CallGroup.Calling".localized)
				.font(AppTheme.shared.fontSet.font(style: .input2))
				.foregroundColor(AppTheme.shared.colorSet.grey5)
				.frame(maxWidth: .infinity, alignment: .center)
				.padding(.top, Constant.spacerTopView)
			
			Text("UI Designs".localized)
				.frame(maxWidth: .infinity, alignment: .center)
				.font(AppTheme.shared.fontSet.font(style: .display2))
				.foregroundColor(AppTheme.shared.colorSet.offWhite)
			
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
			.frame(maxWidth: .infinity, alignment: .top)
			.frame(minHeight: 0, maxHeight: .infinity)
			.padding(.top, Constant.spacerBottom)
			
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
			.padding(.bottom, Constant.paddingButtonNext)
			Spacer()
		}
		.padding(.horizontal, Constant.paddingVertical)
		.onReceive(inspection.notice) { inspection.visit(self, $0) }
		.background(background)
		.edgesIgnoringSafeArea(.all)
		.navigationBarBackButtonHidden(true)
	}
}

// MARK: - Private
private extension CallingGroup {
}

// MARK: - Loading Content
private extension CallingGroup {
	
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

struct CallingGroup_Previews: PreviewProvider {
	static var previews: some View {
		CallingGroup()
	}
}
