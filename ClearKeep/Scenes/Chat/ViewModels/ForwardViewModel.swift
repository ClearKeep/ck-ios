//
//  ForwardViewModel.swift
//  ClearKeep
//
//  Created by Quang Pham on 16/06/2022.
//

import Model
import Foundation

protocol IForwardViewModel {
	var groupModel: IGroupModel { get }
	var isSent: Bool { get set }
}

class ForwardViewModel: IForwardViewModel, ObservableObject {
	var groupModel: IGroupModel
	@Published var isSent: Bool = false
	
	init(groupModel: IGroupModel) {
		self.groupModel = groupModel
	}
}
