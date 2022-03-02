//
//  TextFieldSet.swift
//  ClearKeep
//
//  Created by đông on 01/03/2022.
//

import UIKit
import SwiftUI
import CommonUI

var colorStyle: IColorSet = ColorSet()
var fontStyle: IFontSet = DefaultFontSet()
var imageStyle: IAppImageSet = AppImageSet()

public struct NormalTextField: ViewModifier {
	enum Mode {
		case light, dark

		var bgColor: Color {
			switch self {
			case .light:
				return Color(colorStyle.gray5)
			case .dark:
				return Color(colorStyle.gray5Dark)
			}
		}

		var fgColor: Color {
			switch self {
			case .light:
				return Color(colorStyle.gray3)
			case .dark:
				return Color(colorStyle.gray3Dark)
			}
		}

		var borderColor: Color {
			switch self {
			case .light:
				return Color(colorStyle.gray3)
			case .dark:
				return Color(colorStyle.gray3Dark)
			}
		}

		var imageSet: UIImage {
			switch self {
			case .light:
				return imageStyle.mailIcon
			case .dark:
				return imageStyle.mailIcon
			}
		}
	}

	var mode: Mode
	var image: UIImage
	@Binding var focused: Bool

	public func body(content: Content) -> some View {
		HStack {
			Image(uiImage: image)
				.foregroundColor(mode.fgColor)
				.padding(.leading)
			content
				.font(Font(fontStyle.font(style: .textS)))
				.foregroundColor(mode.fgColor)
				.padding(.leading, 10)
		}
		.frame(width: UIScreen.main.bounds.width - 30, height: 52)
		.background(mode.bgColor)
		.cornerRadius(16)
		.overlay(RoundedRectangle(cornerRadius: 16)
					.stroke(focused ? mode.borderColor : mode.bgColor, lineWidth: 2))
	}
}

struct PasswordTextField: ViewModifier {

	enum Mode {
		case light, dark, error, errorDark

		var bgColor: Color {
			switch self {
			case .light:
				return Color(colorStyle.gray5)
			case .dark:
				return Color(colorStyle.gray5Dark)
			case .error:
				return Color(colorStyle.errorLight)
			case .errorDark:
				return Color(colorStyle.gray5Dark)
			}
		}

		var fgColor: Color {
			switch self {
			case .light:
				return Color(colorStyle.gray1)
			case .dark:
				return Color(colorStyle.gray1)
			case .error:
				return Color(colorStyle.gray3Dark)
			case .errorDark:
				return Color(colorStyle.gray3Dark)
			}
		}

		var borderColor: Color {
			switch self {
			case .light:
				return Color(colorStyle.black)
			case .dark:
				return Color(colorStyle.gray3Dark)
			case .error:
				return Color(colorStyle.errorDark)
			case .errorDark:
				return Color(colorStyle.primary)
			}
		}
	}

	var mode: Mode
	var image: UIImage
	@Binding var focused: Bool

	func body(content: Content) -> some View {
		HStack {
			Image(uiImage: image)
				.padding(.leading)
			content
				.font(Font(fontStyle.font(style: .textS)))
				.foregroundColor(mode.fgColor)
				.padding(.leading, 10)
			Image(uiImage: imageStyle.eyeIcon)
				.padding(.trailing)
		}
		.frame(width: UIScreen.main.bounds.width - 30, height: 52)
		.background(mode.bgColor)
		.cornerRadius(16)
		.overlay(RoundedRectangle(cornerRadius: 16)
					.stroke(focused ? mode.borderColor : mode.bgColor, lineWidth: 2))
	}
}

