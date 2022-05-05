//
//  VoiceGroupCalled.swift
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
	static let sizeButtonCalled = 60.0
	static let spacer = 25.0
	static let spacerBottom = 45.0
	static let spacerButtonCall = 80.0
	static let paddingVertical = 14.0
	static let sizeImage = 120.0
	static let paddingButtonNext = 90.0
	static let borderLineWidth = 2.0
	static let opacity = 0.6
}

struct VoiceGroupCalled: View {
	// MARK: - Variables
	let inspection = ViewInspector<Self>()
	@Environment(\.injected) private var injected: DIContainer
	@Environment(\.colorScheme) private var colorScheme
	@Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
	@State private(set) var samples: Loadable<[IGroupCallModel]>
	@State private(set) var isTappedMute: Bool = false
	@State private(set) var isTappedCamera: Bool = false
	@State private(set) var isTappedSpeaker: Bool = false
	@State private(set) var isTappedEndCall: Bool = false
	@State private var timeCalled = 1
	
	let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
	
	// MARK: - Init
	public init(samples: Loadable<[IGroupCallModel]> = .notRequested) {
		self._samples = .init(initialValue: samples)
	}
	
	// MARK: - Body
	var body: some View {
		VStack {
			ZStack {
				backgroundGradientPrimaryTop.opacity(Constant.opacity)
					.frame(maxWidth: .infinity)
					.frame(height: Constant.paddingButtonNext)
				HStack {
					Button(action: customBack) {
						AppTheme.shared.imageSet.chevleftIcon
							.aspectRatio(contentMode: .fit)
							.foregroundColor(foregroundBackButton)
							.frame(alignment: .leading)
							.padding(.leading, Constant.spacer)
					}
					Text("UI Designs".localized)
						.font(AppTheme.shared.fontSet.font(style: .display3))
						.frame(maxWidth: .infinity, alignment: .leading)
						.padding(.leading, Constant.spacer)
						.foregroundColor(AppTheme.shared.colorSet.offWhite)
					timeCalling
				}
				.padding(.top, Constant.spacerBottom)
			}
			
			VStack {
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
				.padding(.top, Constant.spacerButtonCall)
				Spacer()
				
				VStack {
					Button {
						timeCalled = 0
					} label: {
						ZStack {
							Circle()
								.strokeBorder(AppTheme.shared.colorSet.errorDefault, lineWidth: Constant.borderLineWidth)
								.background(Circle().foregroundColor(AppTheme.shared.colorSet.errorDefault))
								.frame(width: Constant.sizeButtonCalled, height: Constant.sizeButtonCalled)
							AppTheme.shared.imageSet.phoneOffIcon
								.foregroundColor(AppTheme.shared.colorSet.offWhite)
						}
					}
					Text("CallGroup.End".localized)
						.font(AppTheme.shared.fontSet.font(style: .body2))
						.foregroundColor(AppTheme.shared.colorSet.offWhite)
				}
				.padding(.bottom, Constant.paddingButtonNext)
			}
			.padding(.horizontal, Constant.paddingVertical)
		}
		.edgesIgnoringSafeArea(.all)
		.onReceive(inspection.notice) { inspection.visit(self, $0) }
		.background(background)
		.edgesIgnoringSafeArea(.all)
		.navigationBarBackButtonHidden(true)
	}
}

// MARK: - Private
private extension VoiceGroupCalled {
	var timeCalling: some View {
		Text(getTimer())
			.font(AppTheme.shared.fontSet.font(style: .heading3))
			.foregroundColor(AppTheme.shared.colorSet.offWhite)
			.padding()
			.onReceive(timer) { _ in
				if timeCalled > 0 {
					timeCalled += 1
				}
			}
	}
}

// MARK: - Loading Content
private extension VoiceGroupCalled {
}

// MARK: - Color func
private extension VoiceGroupCalled {
	var backgroundDarkGrey2: LinearGradient {
		LinearGradient(gradient: Gradient(colors: [AppTheme.shared.colorSet.darkGrey2, AppTheme.shared.colorSet.darkGrey2]), startPoint: .leading, endPoint: .trailing)
	}
	
	var background: LinearGradient {
		colorScheme == .light ? backgroundGradientPrimary : backgroundDarkGrey2
	}
	
	var foregroundBackButton: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.offWhite : AppTheme.shared.colorSet.greyLight
	}
	
	var backgroundGradientPrimary: LinearGradient {
		LinearGradient(gradient: Gradient(colors: AppTheme.shared.colorSet.gradientPrimary), startPoint: .leading, endPoint: .trailing)
	}
	
	var backgroundGradientPrimaryTop: LinearGradient {
		LinearGradient(gradient: Gradient(colors: AppTheme.shared.colorSet.gradientPrimary), startPoint: .top, endPoint: .bottom)
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
private extension VoiceGroupCalled {
	func customBack() {
		self.presentationMode.wrappedValue.dismiss()
	}
	
	func getTimer() -> String {
		let minutes = Int(timeCalled) / 60 % 60
		let seconds = Int(timeCalled) % 60
		return String(format: "%02i:%02i", minutes, seconds)
	}
}

struct VoiceGroupCalled_Previews: PreviewProvider {
	static var previews: some View {
		VoiceGroupCalled()
	}
}
