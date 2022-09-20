//
//  CallVoiceActionView.swift
//  ClearKeep
//
//  Created by Luong Minh Hiep on 18/05/2021.
//

import SwiftUI
import ChatSecure

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
	
	var callAction: () -> Void
	var endCall: () -> Void
	
	var body: some View {
		GeometryReader { reader in
			VStack {
				Spacer()
					.frame(height: reader.size.height / 2)
				
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
											 action: {
							self.callAction()
						})
						Spacer()
						CallActionButtonView(onIcon: AppTheme.shared.imageSet.speakerIcon2 ,
											 offIcon: AppTheme.shared.imageSet.speakerOffIcon2,
											 isOn: viewModel.speakerEnable,
											 title: "CallGroup.Speaker".localized,
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
											 title: viewModel.callStatus == .answered ? "Call.End".localized : "Call.Cancel".localized,
											 styleButton: .endCall,
											 action: {
							if viewModel.callStatus == .answered {
								self.endCall()
								return
							}
							
							self.viewModel.endCall()
						})
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
