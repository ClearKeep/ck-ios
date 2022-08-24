//
//  CustomVideoView.swift
//  ClearKeep
//
//  Created by Luong Minh Hiep on 25/05/2021.
//

import SwiftUI
import WebRTC
import ChatSecure

struct CustomVideoView: View {
	
	@ObservedObject var videoViewConfig: CustomVideoViewConfig
	let rtcVideoView: RTCMTLEAGLVideoView
	
	var body: some View {
		GeometryReader { _ in
			ZStack {
				VideoView(rtcVideoView: rtcVideoView)
					.rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
					.blur(radius: videoViewConfig.showOptionView ? 70 : 0)
				
				if videoViewConfig.showOptionView {
					if videoViewConfig.microEnable {
						Group {
							VStack {
								CallActionButtonView(onIcon: AppTheme.shared.imageSet.muteIcon,
													 offIcon: AppTheme.shared.imageSet.muteIcon,
													 isOn: true,
													 title: "",
													 styleButton: .video,
													 widthButton: 48,
													 widthInsideIcon: 22,
													 action: {
									videoViewConfig.microEnable.toggle()
								})
								
								Text("Tap to mute")
									.font(AppTheme.shared.fontSet.font(style: .body4))
									.foregroundColor(AppTheme.shared.colorSet.grey4)
									.padding(.bottom, 24)
							}
						}
					} else {
						Group {
							VStack {
								CallActionButtonView(onIcon: AppTheme.shared.imageSet.muteOffIcon,
													 offIcon: AppTheme.shared.imageSet.muteOffIcon,
													 isOn: true,
													 title: "",
													 styleButton: .endCall,
													 widthButton: 48,
													 widthInsideIcon: 22,
													 action: {
									videoViewConfig.microEnable.toggle()
								})
								
								Text("Microphone off")
									.font(AppTheme.shared.fontSet.font(style: .body4))
									.foregroundColor(AppTheme.shared.colorSet.grey4)
									.padding(.bottom, 24)
							}
						}
					}
				}
				
				if !videoViewConfig.showOptionView && !videoViewConfig.microEnable {
					VStack {
						Spacer()
						HStack {
							CallActionButtonView(onIcon: AppTheme.shared.imageSet.muteOffIcon,
												 offIcon: AppTheme.shared.imageSet.muteOffIcon,
												 isOn: true,
												 title: "",
												 styleButton: .endCall,
												 widthButton: 48,
												 widthInsideIcon: 22,
												 action: {
								videoViewConfig.microEnable.toggle()
							})
							.padding(.all, 2)
							Spacer()
						}
					}
					.opacity(0.64)
				}
				
				VStack(alignment: .center) {
					Spacer()
					Text(videoViewConfig.userName)
						.font(AppTheme.shared.fontSet.font(style: .body4))
						.foregroundColor(AppTheme.shared.colorSet.offWhite)
						.padding(.bottom, 24)
				}
			}
			.clipShape(Rectangle())
			.onTapGesture {
				videoViewConfig.triggerOptionDisplayTimeout()
			}
		}
	}
	
	func getFrame(lstVideo: [RTCMTLEAGLVideoView], containerHeight: CGFloat) -> CGSize {
		let indexInTheListList = lstVideo.firstIndex(of: self.rtcVideoView) ?? -1
		var width = UIScreen.main.bounds.size.width / 2
		
		// The first item has full width
		if indexInTheListList == 0 && lstVideo.count % 2 == 1 {
			width = UIScreen.main.bounds.size.width
		}
		
		// If there no more than 2 videos on screen only
		if lstVideo.count <= 2 {
			width = UIScreen.main.bounds.size.width
		}
		
		let height = containerHeight
		switch lstVideo.count {
		case 1:
			return CGSize(width: width, height: height)
		case 2, 3, 4:
			return CGSize(width: width, height: height / 2)
		case 5, 6:
			return CGSize(width: width, height: height / 3)
		case 7, 8:
			return CGSize(width: width, height: height / 4)
			// When number of videos more than 8: allow to scroll
		case let num where num > 8:
			let heightAverage = height / CGFloat(4.2)
			return CGSize(width: width, height: heightAverage)
		default:
			return CGSize(width: 0, height: 0)
		}
	}
	
}

//struct CustomVideoView_Previews: PreviewProvider {
//    static var previews: some View {
//        CustomVideoView()
//    }
//}
