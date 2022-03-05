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
	@Environment(\.colorScheme) var colorScheme
	var colorStyle: IColorSet = ColorSet()
	var fontStyle: IFontSet = DefaultFontSet()
	func makeBody(configuration: Configuration) -> some View {
		configuration.label
			.frame(width: UIScreen.main.bounds.width - 30.0, height: 40.0)
			.font(Font(fontStyle.font(style: .linkS)))
			.background(colorScheme == .light ? Color(colorStyle.offWhite) : Color(colorStyle.primary))
			.foregroundColor(colorScheme == .light ? Color(colorStyle.primary) : Color(colorStyle.offWhite))
			.cornerRadius(40.0)
			.scaleEffect(configuration.isPressed ? 1.2 : 1)
			.animation(.easeOut(duration: 0.2), value: configuration.isPressed)
	}
}

struct BoderButton: ButtonStyle {
	@Environment(\.colorScheme) var colorScheme
	var colorStyle: IColorSet = ColorSet()
	var fontStyle: IFontSet = DefaultFontSet()
	func makeBody(configuration: Configuration) -> some View {
		configuration.label
			.frame(width: UIScreen.main.bounds.width - 80.0, height: 40.0)
			.font(Font(fontStyle.font(style: .linkS)))
			.foregroundColor(colorScheme == .light ? Color(colorStyle.offWhite) : Color(colorStyle.primary))
			.overlay(
				RoundedRectangle(cornerRadius: 40.0)
					.stroke(colorScheme == .light ? Color(colorStyle.offWhite) : Color(colorStyle.primary), lineWidth: 4))
			.scaleEffect(configuration.isPressed ? 1.2 : 1)
			.animation(.easeOut(duration: 0.2), value: configuration.isPressed)
	}
}

struct TextButton: ButtonStyle {
	@Environment(\.colorScheme) var colorScheme
	var colorStyle: IColorSet = ColorSet()
	var fontStyle: IFontSet = DefaultFontSet()
	func makeBody(configuration: Configuration) -> some View {
		configuration.label
			.padding()
			.font(Font(fontStyle.font(style: .linkS)))
			.foregroundColor(colorScheme == .light ? Color(colorStyle.offWhite) : Color(colorStyle.primary))
			.scaleEffect(configuration.isPressed ? 1.2 : 1)
			.animation(.easeOut(duration: 0.2), value: configuration.isPressed)
	}
}

struct IconButton: ButtonStyle {
//	enum Mode {
//		case google, facebook, office
//
//		var iconImage: UIImage {
//			switch self {
//			case .google:
//				return ButtonIcon.google.iconImage
//			case .facebook:
//				return ButtonIcon.facebook.iconImage
//			case .office:
//				return ButtonIcon.office.iconImage
//			}
//		}
//	}
//	var mode: Mode
	var image: UIImage

	func makeBody(configuration: Configuration) -> some View {
		configuration.label
		Image(uiImage: image)
			.frame(width: 54.0, height: 54.0)
			.padding()
			.scaleEffect(configuration.isPressed ? 1.2 : 1)
			.animation(.easeOut(duration: 0.2), value: configuration.isPressed)
	}
}
