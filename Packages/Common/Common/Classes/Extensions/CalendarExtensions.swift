//
//  CalendarExtensions.swift
//  Common
//
//  Created by NamNH on 08/11/2021.
//

import Foundation

// MARK: - Get week days
public extension Calendar {
	func intervalOfWeek(for date: Date) -> DateInterval? {
		dateInterval(of: .weekOfYear, for: date)
	}
	
	func startOfWeek(for date: Date) -> Date? {
		intervalOfWeek(for: date)?.start
	}
	
	func daysWithSameWeekOfYear(as date: Date) -> [Date] {
		guard let startOfWeek = startOfWeek(for: date) else {
			return []
		}
		
		return (0 ... 6).reduce(into: []) { result, daysToAdd in
			result.append(Calendar.current.date(byAdding: .day, value: daysToAdd, to: startOfWeek))
		}
		.compactMap { $0 }
	}
}

// MARK: - Check date
public extension Calendar {
	///
	/// Returns `true` if is today.
	///
	func isToday(date: Date) -> Bool {
		return isDateInToday(date)
	}
	///
	/// Returns `true` if date in current month.
	///
	/// - parameter month: Current month.
	///
	/// - returns: `true` if date in current month.
	///
	func isInCurrentMonth(date: Date, month: Int) -> Bool {
		guard let currentMonth = Date().set(month: month) else { return false }
		return isDate(date, equalTo: currentMonth, toGranularity: .month)
	}
}
