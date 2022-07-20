//
//  CallVoiceActionView.swift
//  ClearKeep
//
//  Created by Luong Minh Hiep on 18/05/2021.
//

import SwiftUI

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

struct CallVoiceActionView: View {
	@ObservedObject var viewModel: CallViewModel
	
	var body: some View {
		GeometryReader { reader in
			VStack {
				Spacer()
					.frame(height: reader.size.height/2)
				
				VStack {
					HStack(spacing: 16) {
						Spacer()
						CallActionButtonView(onIcon: AppTheme.shared.imageSet.muteIcon,
											 offIcon: AppTheme.shared.imageSet.muteOffIcon,
											 isOn: viewModel.microEnable,
											 title: "Call.Mute".localized,
											 styleButton: .voice,
											 action: viewModel.microChange)
						Spacer()
						CallActionButtonView(onIcon: AppTheme.shared.imageSet.cameraIcon,
											 offIcon: AppTheme.shared.imageSet.cameraOffIcon,
											 isOn: viewModel.cameraOn,
											 title: "Call.Camera".localized,
											 styleButton: .voice,
											 action: viewModel.updateCallTypeVideo)
						Spacer()
						CallActionButtonView(onIcon: AppTheme.shared.imageSet.speakerOffIcon2,
											 offIcon: AppTheme.shared.imageSet.speakerIcon2,
											 isOn: viewModel.speakerEnable,
											 title: "Speaker",
											 styleButton: .voice,
											 action: viewModel.speakerChange)
						Spacer()
					}
					
					Spacer()
					
					HStack {
						Spacer()
						CallActionButtonView(onIcon: AppTheme.shared.imageSet.phoneOffIcon,
											 offIcon: AppTheme.shared.imageSet.phoneOffIcon,
											 isOn: true,
											 title: "End Call",
											 styleButton: .endCall,
											 action: { viewModel.endCall() })
						Spacer()
					}
				} .frame(width: reader.size.width)
					.padding(.vertical, 16)
					.padding(.bottom, 48)
			}
			.background(Color.clear)
		}
	}
}

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

struct CallVoiceActionView_Previews: PreviewProvider {
	static var previews: some View {
		CallVoiceActionView(viewModel: CallViewModel())
			.background(Color.blue)
	}
}
