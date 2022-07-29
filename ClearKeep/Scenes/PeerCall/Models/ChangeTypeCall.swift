//
//  ChangeTypeCall.swift
//  ClearKeep
//
//  Created by HOANDHTB on 25/07/2022.
//

import UIKit
import ChatSecure
import Networking
import Model

struct ChangeTypeCall: IVideoCallModel {
	var error: String?
}

extension ChangeTypeCall {
	init(data: VideoCall_BaseResponse) {
		self.error = data.error
	}
}
