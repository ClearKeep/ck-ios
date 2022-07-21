//
//  GroupDetailBaseViewModel.swift
//  ClearKeep
//
//  Created by MinhDev on 27/06/2022.
//

import Model
import ChatSecure
import Networking

struct GroupDetailBaseViewModel {
	var error: String
}

extension GroupDetailBaseViewModel {
	init(_ response: IGroupBaseResponse) {
		self.init(error: response.error)
	}
}
