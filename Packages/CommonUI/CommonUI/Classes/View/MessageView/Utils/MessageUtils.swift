//
//  MessageUtils.swift
//  
//
//  Created by NamNH on 20/03/2022.
//

import UIKit
import SwiftUI
import Common

private enum Constants {
	static let remoteImageRegex = "(https://s3.amazonaws.com/storage.clearkeep.io/[a-zA-Z0-9\\/\\_\\-\\.]+(\\.png|\\.jpeg|\\.jpg|\\.gif|\\.heic|\\.PNG|\\.JPEG|\\.JPG|\\.GIF|\\.HEIC))"
	static let remoteFileRegex = "(https://s3.amazonaws.com/storage.clearkeep.io/.+)"
	static let fileNameRegex = "(?:.(?!\\/))+$"
	static let fileSizeRegex = "\\|.+"
}

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
				return [.topRight, .bottomRight, .bottomLeft]
			case size - 1:
				return [.topLeft, .topRight, .bottomRight]
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
	
	static func getImageUriStrings(content: String) -> [String] {
		let regex = NSRegularExpression(Constants.remoteImageRegex)
		return regex.matchList(content)
	}
	
	static func getImageMessageContent(content: String) -> String? {
		do {
			let regex = try NSRegularExpression(pattern: Constants.remoteImageRegex, options: [])
			let nsString = NSString(string: content)
			let result = regex.stringByReplacingMatches(in: content, range: NSRange(location: 0, length: nsString.length), withTemplate: "").trimmingCharacters(in: .whitespaces)
			return result.isEmpty ? nil : result
		} catch let error {
			print("invalid regex: \(error.localizedDescription)")
			return nil
		}
	}
	
	public static func isImageMessage(message: String) -> Bool {
		let regex = NSRegularExpression(Constants.remoteImageRegex)
		return regex.matches(message)
	}
	
	public static func isFileMessage(message: String) -> Bool {
		let regex = NSRegularExpression(Constants.remoteFileRegex)
		return regex.matches(message)
	}
	
	static func getFileUriStrings(content: String) -> [String] {
		return content.components(separatedBy: " ")
	}
	
	public static func getFileDownloadURL(content: String) -> String {
		do {
			let regex = try NSRegularExpression(pattern: Constants.fileSizeRegex, options: [])
			return regex.stringByReplacingMatches(in: content, range: NSRange(location: 0, length: content.utf16.count), withTemplate: "")
		} catch let error {
			print("invalid regex: \(error.localizedDescription)")
			return ""
		}
	}
	
	static func getFileSizeInBytesFromUrl(url: String) -> Int64 {
		do {
			let regex = try NSRegularExpression(pattern: Constants.fileSizeRegex, options: [])
			let nsString = NSString(string: url)
			if let result = regex.firstMatch(in: url, range: NSRange(location: 0, length: nsString.length)) {
				let sizeString = nsString.substring(with: result.range)
				return Int64(sizeString.dropFirst()) ?? 0
			} else {
				return 0
			}
		} catch let error {
			print("invalid regex: \(error.localizedDescription)")
			return 0
		}
	}
	
	static func getFileSizeInMegabytesString(url: String) -> String {
		let fileSizeInBytes = getFileSizeInBytesFromUrl(url: url)
		
		var unit = ""
		var fileSizeInMegabytes: Double = 0
		
		if fileSizeInBytes < 1024 {
			unit = "B"
			return "\(fileSizeInBytes) \(unit)"
		} else if fileSizeInBytes < 1024 * 1_000 {
			unit = "kB"
			fileSizeInMegabytes = Double(fileSizeInBytes) / 1_000
			return String(format: "%.2f \(unit)", fileSizeInMegabytes)
		} else {
			unit = "MB"
			fileSizeInMegabytes = Double(fileSizeInBytes) / 1_000_000
			return String(format: "%.2f \(unit)", fileSizeInMegabytes)
		}
	}
	
	static func getFileNameFromUrl(url: String) -> String {
		do {
			let regex = try NSRegularExpression(pattern: Constants.fileNameRegex, options: [])
			let nsString = NSString(string: url)
			if let result = regex.firstMatch(in: url, range: NSRange(location: 0, length: nsString.length)) {
				let resultString = nsString.substring(with: result.range)
				let sizeRegex = try NSRegularExpression(pattern: Constants.fileSizeRegex, options: [])
				var fileName = sizeRegex.stringByReplacingMatches(in: resultString, range: NSRange(location: 0, length: NSString(string: resultString).length), withTemplate: "")
				return String(fileName.dropFirst())
			} else {
				return ""
			}
		} catch let error {
			print("invalid regex: \(error.localizedDescription)")
			return ""
		}
	}
}
