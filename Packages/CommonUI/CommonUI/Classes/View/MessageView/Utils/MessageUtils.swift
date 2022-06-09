//
//  MessageUtils.swift
//  
//
//  Created by NamNH on 20/03/2022.
//

import UIKit
import SwiftUI
import Common

public class MessageUtils {
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
											rectCorner: message.isMine ? self.getOwnerRectCorner(isQuoteMessage: message.isQuoteMessage, index: index, size: groupedSize) : self.getOtherRectCorner(isQuoteMessage: message.isQuoteMessage, isForwardMessage: message.isForwardedMessage, index: index, size: groupedSize),
											isDisplayAvatarAndUserName: self.isShowAvatarAndUserName(index: index, size: groupedSize))
			}
			listMessageDisplay.append(contentsOf: list)
		}
		return listMessageDisplay
	}
	
	static func isShowAvatarAndUserName(index: Int, size: Int) -> Bool {
		return size == 1 ? true : index == 0 ? true : false
	}
	
	static func getOwnerRectCorner(isQuoteMessage: Bool, index: Int, size: Int) -> UIRectCorner {
		if isQuoteMessage {
			return [.topLeft, .bottomLeft]
		}
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
	
	static func getOtherRectCorner(isQuoteMessage: Bool, isForwardMessage: Bool, index: Int, size: Int) -> UIRectCorner {
		if isQuoteMessage {
			return [.topRight, .bottomRight]
		}
		if (isForwardMessage && size == 1) || (isForwardMessage && index == 0) {
			return [.topRight, .bottomLeft, .bottomRight]
		}
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
	
	public static func getTimeAsString(timeMs: Int64, includeTime: Bool = false) -> String {
		let nowTime = Date()
		
		let inputTime = Date(timeIntervalSince1970: TimeInterval(timeMs / 1000))
		
		let time = includeTime ? " at \(dateString(date: inputTime, format: "hh:mm aa"))" : ""
		
		if inputTime.year == nowTime.year
			&& inputTime.month == nowTime.month
			&& inputTime.weekOfMonth == nowTime.weekOfMonth {
			if inputTime.day == nowTime.day {
				return "Today\(time)"
			} else if nowTime.day - inputTime.day == 1 {
				return "Yesterday\(time)"
			} else {
				return dateString(date: inputTime, format: "EEE")
			}
		} else {
			return dateString(date: inputTime, format: "yyyy/MM/dd")
		}
	}
	
	static func dateString(date: Date, format: String) -> String {
		let formatDate = DateFormatter()
		formatDate.dateFormat = format
		return formatDate.string(from: date)
	}
	
	static func showMessageDate(
		for message: MessageDisplayInfoViewModel,
		in messages: [MessageDisplayInfoViewModel]
	) -> String? {
		let index = messages.firstIndex { msg in
			msg.message.id == message.message.id
		}
		guard let index = index else {
			return nil
		}

		let message = messages[index]
		let previousIndex = index + 1
				
		if previousIndex < messages.count {
			let previous = messages[previousIndex]
			let isDifferentDay = !Calendar.current.isDate(
				Date(timeIntervalSince1970: TimeInterval(message.message.dateCreated / 1000)),
				equalTo: Date(timeIntervalSince1970: TimeInterval(previous.message.dateCreated / 1000)),
				toGranularity: .day
			)
			if isDifferentDay {
				return getTimeAsString(timeMs: message.message.dateCreated)
			} else {
				return nil
			}
		} else {
			return getTimeAsString(timeMs: message.message.dateCreated)
		}
	}
}
