//
//  CKSignalProtocolAddress.swift
//  ChatSecure
//
//  Created by NamNH on 21/04/2022.
//

import Networking
import SignalProtocolObjC

class CKSignalProtocolAddress: SignalAddress {
	private var owner: IOwner
	
	init(owner: IOwner, deviceId: Int) {
		self.owner = owner
		super.init(name: "\(owner.clientId)_\(owner.domain)", deviceId: Int32(deviceId))
	}
}
