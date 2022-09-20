//
//  Date + Timer.swift
//  ClearKeep
//
//  Created by MinhDev on 05/08/2022.
//

import Foundation

public func getTimeAsString(timeMs: Int64, includeTime: Bool = false) -> String {
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

public func dateString(date: Date, format: String) -> String {
	let formatDate = DateFormatter()
	formatDate.dateFormat = format
	return formatDate.string(from: date)
}
