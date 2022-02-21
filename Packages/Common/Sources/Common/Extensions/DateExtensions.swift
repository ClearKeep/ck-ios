//
//  DateExtensions.swift
//  Common
//
//  Created by NamNH on 02/10/2021.
//

import Foundation

// swiftlint:disable multiline_parameters_brackets
public extension Date {
	///
	/// Returns day of date.
	///
	var day: Int {
		return Calendar(identifier: .gregorian).component(.day, from: self)
	}
	///
	/// Returns month of date.
	///
	var month: Int {
		return Calendar(identifier: .gregorian).component(.month, from: self)
	}
	///
	/// Returns year of date.
	///
	var year: Int {
		return Calendar(identifier: .gregorian).component(.year, from: self)
	}
	///
	/// Returns day of week.
	///
	var weekday: Int {
		return Calendar(identifier: .gregorian).component(.weekday, from: self)
	}
	///
	/// Returns the tuple `hours, minute, second` from a specified second.
	///
	/// - parameter second: A specified second value.
	///
	/// - returns: a tuple `hours, minute, second`
	///
	static func getHourMinuteSecond(from second: Int) -> (hour: Int, minute: Int, second: Int) {
		return (second / 3600, (second % 3600) / 60, (second % 3600) % 60)
	}
	///
	/// Returns the `string` describe date by string.
	///
	/// - parameter format: A specified format.
	/// - parameter calendar: A specified calendar. `default` is current calendar.
	/// - parameter timeZone: A specified time zone. `default` is current time zone.
	///
	/// - returns: Returns the `string` describe date by string with specified format, calendar, time zone.
	///
	func stringBy(format: String, calendar: Calendar = Calendar.current, timeZone: TimeZone = TimeZone.current) -> String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = format
		dateFormatter.calendar = calendar
		dateFormatter.timeZone = timeZone
		return dateFormatter.string(from: self)
	}
	///
	/// Returns the `string` describe time ago from date to current time.
	///
	/// - parameter maxDay: Max number of day to show full date format. `default` is 7 days.
	/// - parameter format: A specified format. `default` is `dd/MM/yyyy`.
	/// - parameter calendar: A specified calendar. `default` is current calendar.
	/// - parameter timeZone: A specified time zone. `default` is current time zone.
	///
	/// - returns: Returns the `string` describe time ago from date to current time.
	///
	func timeAgoSinceDate(maxDay: Int = 7,
						  format: String = "dd/MM/yyyy",
						  calendar: Calendar = Calendar.current,
						  timeZone: TimeZone = TimeZone.current) -> String {
		
		// From Time
		let fromDate = self
		
		// To Time
		let toDate = Date()
		
		// Estimation
		if let interval = Calendar.current.dateComponents([.day], from: fromDate, to: toDate).day, interval > maxDay {
			return self.stringBy(format: format, calendar: calendar, timeZone: timeZone)
		}
		
		// Day
		if let interval = Calendar.current.dateComponents([.day], from: fromDate, to: toDate).day, interval >= 1 {
			return interval == 1 ? "\(interval)" + " " + "Date.Yesterday".localized : "\(interval)" + " " + "Date.Days.Ago".localized
		}
		
		// Hour
		if let interval = Calendar.current.dateComponents([.hour], from: fromDate, to: toDate).hour, interval > 0 {
			return String(format: "Date.Hours.Ago".localized, interval)
		}
		
		// Minute
		if let interval = Calendar.current.dateComponents([.minute], from: fromDate, to: toDate).minute, interval > 0 {
			return String(format: "Date.Minutes.Ago".localized, interval)
		}
		
		return "Date.Now".localized
	}
}

// MARK: - Create date
public extension Date {
	func set(year: Int, month: Int, day: Int, calendar: Calendar = Calendar.current, timeZone: TimeZone = TimeZone.current) -> Date? {
		return self.set(year: year, calendar: calendar, timeZone: timeZone)?
			.set(month: month, calendar: calendar, timeZone: timeZone)?
			.set(day: day, calendar: calendar, timeZone: timeZone)
	}
	
	func set(hour: Int, minute: Int, second: Int, calendar: Calendar = Calendar.current, timeZone: TimeZone = TimeZone.current) -> Date? {
		return self.set(hour: hour, calendar: calendar, timeZone: timeZone)?
			.set(minute: minute, calendar: calendar, timeZone: timeZone)?
			.set(second: second, calendar: calendar, timeZone: timeZone)
	}
	
	func set(year: Int, calendar: Calendar = Calendar.current, timeZone: TimeZone = TimeZone.current) -> Date? {
		var components = self.getComponents(calendar: calendar, timeZone: timeZone)
		components.year = year
		return calendar.date(from: components)
	}
	
	func set(month: Int, calendar: Calendar = Calendar.current, timeZone: TimeZone = TimeZone.current) -> Date? {
		var components = self.getComponents(calendar: calendar, timeZone: timeZone)
		components.month = month
		return calendar.date(from: components)
	}
	
	func set(day: Int, calendar: Calendar = Calendar.current, timeZone: TimeZone = TimeZone.current) -> Date? {
		var components = self.getComponents(calendar: calendar, timeZone: timeZone)
		components.day = day
		return calendar.date(from: components)
	}
	
	func set(hour: Int, calendar: Calendar = Calendar.current, timeZone: TimeZone = TimeZone.current) -> Date? {
		var components = self.getComponents(calendar: calendar, timeZone: timeZone)
		components.hour = hour
		return calendar.date(from: components)
	}
	
	func set(minute: Int, calendar: Calendar = Calendar.current, timeZone: TimeZone = TimeZone.current) -> Date? {
		var components = self.getComponents(calendar: calendar, timeZone: timeZone)
		components.minute = minute
		return calendar.date(from: components)
	}
	
	func set(second: Int, calendar: Calendar = Calendar.current, timeZone: TimeZone = TimeZone.current) -> Date? {
		var components = self.getComponents(calendar: calendar, timeZone: timeZone)
		components.second = second
		return calendar.date(from: components)
	}
}

private extension Date {
	func getComponents(calendar: Calendar = Calendar.current, timeZone: TimeZone = TimeZone.current) -> DateComponents {
		let dateComponents = DateComponents(calendar: calendar,
											timeZone: timeZone,
											era: calendar.component(.era, from: self),
											year: calendar.component(.year, from: self),
											month: calendar.component(.month, from: self),
											day: calendar.component(.day, from: self),
											hour: calendar.component(.hour, from: self),
											minute: calendar.component(.minute, from: self),
											second: calendar.component(.second, from: self),
											nanosecond: calendar.component(.nanosecond, from: self),
											weekday: calendar.component(.weekday, from: self),
											weekdayOrdinal: calendar.component(.weekdayOrdinal, from: self),
											quarter: calendar.component(.quarter, from: self),
											weekOfMonth: calendar.component(.weekOfMonth, from: self),
											weekOfYear: calendar.component(.weekOfYear, from: self),
											yearForWeekOfYear: calendar.component(.yearForWeekOfYear, from: self))
		return dateComponents
	}
}
