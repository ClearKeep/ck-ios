//
//  MessageUtils.swift
//  
//
//  Created by NamNH on 20/03/2022.
//

import UIKit
import SwiftUI

class MessageUtils {
	static func separateMessageList(messages: [IMessageViewModel]) -> [[IMessageViewModel]] {
		var result: [[IMessageViewModel]] = []
		var cache: [IMessageViewModel] = []
		var currentSenderId = ""
		
		messages.forEach { (message) in
			if currentSenderId.isEmpty || currentSenderId != message.fromClientId {
				currentSenderId = message.fromClientId
				if !cache.isEmpty {
					result.append(cache)
				}
				cache = []
			}
			cache.append(message)
		}
		result.append(cache)
		
		return result
	}
	
	static func getListRectCorner(messages: [IMessageViewModel]) -> [MessageDisplayInfoViewModel] {
		let separateMessageList = self.separateMessageList(messages: messages)
		var listMessageDisplay: [MessageDisplayInfoViewModel] = []
		separateMessageList.forEach { subList in
			let groupedSize = subList.count
			let list = subList.enumerated().map { (index, message) in
				MessageDisplayInfoViewModel(message: message,
											rectCorner: message.isMine ? self.getOwnerRectCorner(index: index, size: groupedSize) : self.getOtherRectCorner(index: index, size: groupedSize),
											isDisplayAvatarAndUserName: self.isShowAvatarAndUserName(index: index, size: groupedSize))
			}
			listMessageDisplay.append(contentsOf: list)
		}
		return listMessageDisplay
	}
	
	static func isShowAvatarAndUserName(index: Int, size: Int) -> Bool {
		return size == 1 ? true : index == 0 ? true : false
	}
	
	static func getOwnerRectCorner(index: Int, size: Int) -> UIRectCorner {
		if size == 1 {
			return [.topLeft, .topRight, .bottomLeft]
		} else {
			switch index {
			case 0:
				return [.topLeft, .topRight, .bottomLeft]
			case size - 1:
				return [.topLeft, .bottomRight, .bottomLeft]
			default:
				return [.topLeft, .bottomLeft]
			}
		}
	}
	
	static func getOtherRectCorner(index: Int, size: Int) -> UIRectCorner {
		if size == 1 {
			return [.topLeft, .topRight, .bottomRight]
		} else {
			switch index {
			case 0:
				return [.topLeft, .topRight, .bottomRight]
			case size - 1:
				return [.topRight, .bottomLeft, .bottomRight]
			default:
				return [.topRight, .bottomRight]
			}
		}
	}
}
