//
//  IPeerViewModels.swift
//  ClearKeep
//
//  Created by HOANDHTB on 25/07/2022.
//

import Foundation
import Model
import CommonUI
import ChatSecure

protocol IPeerViewModels {
	var callVideoModel: IVideoCallModel? { get }
}

struct PeerViewModels: IPeerViewModels {
	var callVideoModel: IVideoCallModel?
}

extension PeerViewModels {
	init(callVideoModel: IVideoCallModel) {
		self.callVideoModel = callVideoModel
	}
}
