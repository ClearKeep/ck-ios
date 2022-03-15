//
//  ExtensionColor.swift
//  ClearKeep
//
//  Created by đông on 15/03/2022.
//

import SwiftUI

extension Color {
	public static func backgroundScheme(colorScheme: ColorScheme) -> LinearGradient {
		colorScheme == .light ? backgroundGradientPrimary : backgroundColorDark
	}

	public static var backgroundGradientPrimary: LinearGradient {
		LinearGradient(gradient: Gradient(colors: AppTheme.shared.colorSet.gradientPrimary), startPoint: .leading, endPoint: .trailing)
	}

	public static var backgroundColorWhite: LinearGradient {
		LinearGradient(gradient: Gradient(colors: [AppTheme.shared.colorSet.offWhite, AppTheme.shared.colorSet.offWhite]), startPoint: .leading, endPoint: .trailing)
	}

	public static var backgroundColorDark: LinearGradient {
		LinearGradient(gradient: Gradient(colors: [AppTheme.shared.colorSet.black, AppTheme.shared.colorSet.black]), startPoint: .leading, endPoint: .trailing)
	}

	public static func backgroundColorGradient(_ colorScheme: ColorScheme) -> LinearGradient {
		LinearGradient(gradient: Gradient(colors: AppTheme.shared.colorSet.gradientPrimary), startPoint: .leading, endPoint: .trailing)
	}

	public static func backgroundColorDarkView(_ colorScheme: ColorScheme) -> LinearGradient {
		colorScheme == .light ? backgroundColorWhite : backgroundColorGradient(colorScheme)
	}

	public static func foregroundColorWhite(_ colorScheme: ColorScheme) -> Color {
		colorScheme == .light ? AppTheme.shared.colorSet.offWhite : AppTheme.shared.colorSet.offWhite
	}

	public static func foregroundColorPrimary(_ colorScheme: ColorScheme) -> Color {
		AppTheme.shared.colorSet.primaryDefault
	}

	public static func foregroundColorView(_ colorScheme: ColorScheme) -> Color {
		colorScheme == .light ? foregroundColorPrimary(colorScheme) : foregroundColorWhite(colorScheme)
	}

	public static func foregroundColorMessage(_ colorScheme: ColorScheme) -> Color {
		colorScheme == .light ? foregroundColorWhite(colorScheme) : foregroundColorPrimary(colorScheme)
	}

	public static var foregroundColorBackground: Color {
		AppTheme.shared.colorSet.background
	}

	public static var foregroundColorGrey: Color {
		AppTheme.shared.colorSet.grey1
	}

	public static func foregroundMessage(_ colorScheme: ColorScheme) -> Color {
		colorScheme == .light ? foregroundColorBackground : foregroundColorGrey
	}
}

extension Binding {
	func safeBinding<T>(defaultValue: T) -> Binding<T> where Value == Optional<T> {
		.init {
			self.wrappedValue ?? defaultValue
		} set: { newValue in
			self.wrappedValue = newValue
		}
	}
}
