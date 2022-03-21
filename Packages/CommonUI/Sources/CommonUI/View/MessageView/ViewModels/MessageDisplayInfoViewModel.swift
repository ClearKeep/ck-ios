//
//  MessageDisplayInfoViewModel.swift
//  
//
//  Created by NamNH on 20/03/2022.
//

import SwiftUI
import UIKit

public protocol IMessageDisplayInfoViewModel {
	var message: IMessageViewModel { get }
	var rectCorner: UIRectCorner { get }
	var isDisplayAvatarAndUserName: Bool { get }
}

public struct MessageDisplayInfoViewModel {
	public let message: IMessageViewModel
	public let rectCorner: UIRectCorner
	public let isDisplayAvatarAndUserName: Bool
	
	public init(message: IMessageViewModel,
				rectCorner: UIRectCorner,
				isDisplayAvatarAndUserName: Bool) {
		self.message = message
		self.rectCorner = rectCorner
		self.isDisplayAvatarAndUserName = isDisplayAvatarAndUserName
	}
}

extension MessageDisplayInfoViewModel: IMessageDisplayInfoViewModel {}
