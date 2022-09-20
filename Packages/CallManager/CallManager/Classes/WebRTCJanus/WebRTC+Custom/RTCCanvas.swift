//
//  RTCCanvas.swift
//  JanusWebRTC
//
//  Created by VietAnh on 12/21/20.
//  Copyright © 2020 Vmodev. All rights reserved.
//

import UIKit

class RTCCanvas {
	let view: UIView
	let renderMode: RTCRenderMode
	let uid: Int
	var renderView: UIView?
	
	init(canvasWithUid uid: Int, view: UIView, renderMode: RTCRenderMode) {
		self.uid = uid
		self.view = view
		self.renderMode = renderMode
	}
}
