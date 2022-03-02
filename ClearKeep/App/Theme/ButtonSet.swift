//
//  ButtonSet.swift
//  ClearKeep
//
//  Created by MinhDev on 01/03/2022.
//

import SwiftUI
import UIKit
import CommonUI

struct PrimaryButton: ButtonStyle {
	enum Mode {
		case light, dark
		var bgColor: Color {
			switch self {
			case .light:
				return Color(ButtonStyles.primary.backgroundColor)
			case .dark:
				return Color(ButtonStyles.primary.backgroundColor)
			}
		}
		var fgColor: Color {
			switch self {
			case .light:
				return Color(ButtonStyles.primary.textColor)
			case .dark:
				return Color(ButtonStyles.primary.textColor)
			}
		}
	}
	var fontStyle: IFontSet = DefaultFontSet()
	var mode: Mode
	func makeBody(configuration: Configuration) -> some View {
		configuration.label
			.frame(width: UIScreen.main.bounds.width - 20.0, height: 40.0)
			.padding()
			.font(Font(fontStyle.font(style: .textS)))
			.background(mode.bgColor)
			.foregroundColor(mode.fgColor)
			.cornerRadius(40.0)
			.scaleEffect(configuration.isPressed ? 1.2 : 1)
			.animation(.easeOut(duration: 0.2), value: configuration.isPressed)
	}
}

struct BoderButton: ButtonStyle {
	enum Mode {
		case light, dark
		
		var bgColor: Color {
			switch self {
			case .light:
				return Color(ButtonStyles.border.borderColor)
			case .dark:
				return Color(ButtonStyles.secondary.borderColor)
			}
		}
		var fgColor: Color {
			switch self {
			case .light:
				return Color(ButtonStyles.border.backgroundColor)
			case .dark:
				return Color(ButtonStyles.subtle.borderColor)
			}
		}
		var boder: Color {
			switch self {
			case .light:
				return Color(ButtonStyles.border.backgroundColor)
			case .dark:
				return Color(ButtonStyles.border.backgroundColor)
			}
		}
	}
	var fontStyle: IFontSet = DefaultFontSet()
	var mode: Mode
	func makeBody(configuration: Configuration) -> some View {
		configuration.label
			.frame(width: UIScreen.main.bounds.width - 80.0, height: 40.0)
			.padding()
			.font(Font(fontStyle.font(style: .textS)))
			.foregroundColor(mode.fgColor)
			.overlay(
				RoundedRectangle(cornerRadius: 40.0)
					.stroke(mode.fgColor, lineWidth: 2))
			.scaleEffect(configuration.isPressed ? 1.2 : 1)
			.animation(.easeOut(duration: 0.2), value: configuration.isPressed)
	}
}

struct TextButton: ButtonStyle {
	enum Mode {
		case light, dark
		
		var fgColor: Color {
			switch self {
			case .light:
				return Color(ButtonStyles.disabled.textColor)
			case .dark:
				return Color(ButtonStyles.primary.textColor)
			}
		}
	}
	var fontStyle: IFontSet = DefaultFontSet()
	var mode: Mode
	func makeBody(configuration: Configuration) -> some View {
		configuration.label
			.padding()
			.font(Font(fontStyle.font(style: .linkS)))
			.foregroundColor(mode.fgColor)
			.overlay(
				RoundedRectangle(cornerRadius: 40.0)
					.stroke(mode.fgColor, lineWidth: 2))
			.scaleEffect(configuration.isPressed ? 1.2 : 1)
			.animation(.easeOut(duration: 0.2), value: configuration.isPressed)
	}
}

struct IconButton: ButtonStyle {
	enum Mode {
		case google, facebook, office
		
		var iconImage: UIImage {
			switch self {
			case .google:
				return ButtonIcon.google.iconImage
			case .facebook:
				return ButtonIcon.facebook.iconImage
			case .office:
				return ButtonIcon.office.iconImage
			}
		}
	}
	var mode: Mode
	func makeBody(configuration: Configuration) -> some View {
		configuration.label
		Image(uiImage: mode.iconImage)
			.frame(width: 54.0, height: 54.0)
			.padding()
			.scaleEffect(configuration.isPressed ? 1.2 : 1)
			.animation(.easeOut(duration: 0.2), value: configuration.isPressed)
	}
}
