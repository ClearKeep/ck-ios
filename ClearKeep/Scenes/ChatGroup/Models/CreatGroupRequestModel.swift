//
//  CreatGroupRequestModel.swift
//  ClearKeep
//
//  Created by MinhDev on 09/06/2022.
//

import Model
import ChatSecure
import Networking

struct GroupRequestModel: IGroupClientRequest {
	var id: String
	var displayName: String
	var workspaceDomain: String
}

extension GroupRequestModel {
	init(_ clientRequest: Group_ClientInGroupObject) {
		self.init(id: clientRequest.id,
				  displayName: clientRequest.displayName,
				  workspaceDomain: clientRequest.workspaceDomain)
	}
}
