//
//  VideoView.swift
//  ClearKeep
//
//  Created by VietAnh on 1/4/21.
//

import Foundation
import SwiftUI
import WebRTC

#if arch(arm64)
typealias RTCMTLEAGLVideoView = RTCMTLVideoView
#else
typealias RTCMTLEAGLVideoView = RTCEAGLVideoView
#endif

// #if arch(arm64)
struct VideoView: UIViewRepresentable {
	let rtcVideoView: RTCMTLEAGLVideoView
	
	func makeUIView(context: Context) -> RTCMTLEAGLVideoView {
#if arch(arm64)
		rtcVideoView.videoContentMode = .scaleAspectFill
#else
#endif
		return rtcVideoView
	}
	
	func updateUIView(_ uiView: RTCMTLEAGLVideoView, context: Context) {
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
