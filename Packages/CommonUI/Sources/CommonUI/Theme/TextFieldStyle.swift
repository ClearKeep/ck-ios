//
//  File.swift
//  
//
//  Created by đông on 26/02/2022.
//

import SwiftUI

struct NormalTextField: ViewModifier {

	enum Mode {
		case light, dark, error, errorDark

		var bgColor: Color {
			switch self {
			case .light:
				return Color(commonUIConfig.colorSet.gray5)
			case .dark:
				return Color(commonUIConfig.colorSet.gray5Dark)
			}
		}
		var fgColor: Color {
			switch self {
			case .light:
				return Color(commonUIConfig.colorSet.gray3)
			case .dark:
				return Color(commonUIConfig.colorSet.gray3Dark)
			}
		}

		var borderColor: Color {
			switch self {
			case .light:
				return Color(commonUIConfig.colorSet.gray3)
			case .dark:
				return Color(commonUIConfig.colorSet.gray3Dark)
			}
		}
	}

	var mode: Mode
	var image: String

	func body(content: Content) -> some View {
		HStack {
			Image(uiImage: UIImage(named: image) ?? UIImage())
				.padding(.leading)
			content
				.font(Font(commonUIConfig.fontSet.font(style: .textS)))
				.foregroundColor(mode.fgColor)
		}
		.frame(width: 313, height: 52)
		.background(mode.bgColor)
		.cornerRadius(16)
	}
}

struct PasswordTextField: ViewModifier {

	enum Mode {
		case light, dark, error, errorDark

		var bgColor: Color {
			switch self {
			case .light:
				return Color(commonUIConfig.colorSet.gray5)
			case .dark:
				return Color(commonUIConfig.colorSet.gray5Dark)
			case .error:
				return Color(commonUIConfig.colorSet.errorLight)
			case .errorDark:
				return Color(commonUIConfig.colorSet.)
			}
		}
		var fgColor: Color {
			switch self {
			case .light:
				return Color(commonUIConfig.colorSet.gray3)
			case .dark:
				return Color(commonUIConfig.colorSet.gray3Dark)
			case .error:
				return Color(commonUIConfig.colorSet.errorLight)
			case .errorDark:
				return Color(commonUIConfig.colorSet.errorLight)
			}
		}
	}

	var mode: Mode
	var image: String

	func body(content: Content) -> some View {
		HStack {
			Image(uiImage: UIImage(named: image) ?? UIImage())
				.padding(.leading)
			content
				.font(Font(commonUIConfig.fontSet.font(style: .textS)))
				.foregroundColor(mode.fgColor)
			Image(uiImage: UIImage(named: "Lock") ?? UIImage())
				.padding(.trailing)
		}
		.frame(width: 313, height: 52)
		.background(mode.bgColor)
		.cornerRadius(16)
	}
}

struct PasswordTextFieldError: ViewModifier {

	enum Mode {
		case light, dark

		var bgColor: Color {
			switch self {
			case .light:
				return Color(commonUIConfig.colorSet.errorLight)
			case .dark:
				return Color(commonUIConfig.colorSet.gray5Dark)
			}
		}
		var fgColor: Color {
			switch self {
			case .light:
				return Color(commonUIConfig.colorSet.gray3)
			case .dark:
				return Color(commonUIConfig.colorSet.gray3Dark)
			}
		}

		var borderColor: Color {
			switch self {
			case .light:
				return Color(commonUIConfig.colorSet.errorDark)
			case .dark:
				return Color(commonUIConfig.colorSet.primary)
			}
		}
	}

	var mode: Mode
	var image: String

	func body(content: Content) -> some View {
		HStack {
			Image(uiImage: UIImage(named: image) ?? UIImage())
				.padding(.leading)
			content
				.font(Font(commonUIConfig.fontSet.font(style: .textS)))
				.foregroundColor(mode.fgColor)
			Image(uiImage: UIImage(named: "Lock") ?? UIImage())
				.padding(.trailing)
		}
		.frame(width: 313, height: 52)
		.background(mode.bgColor)
		.cornerRadius(16)
		.overlay(
			RoundedRectangle(cornerRadius: 16)
				.stroke(mode.borderColor, lineWidth: 1))
	}
}
