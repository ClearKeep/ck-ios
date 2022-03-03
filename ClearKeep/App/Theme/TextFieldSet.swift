//
//  TextFieldSet.swift
//  ClearKeep
//
//  Created by đông on 01/03/2022.
//

import UIKit
import SwiftUI
import CommonUI

public struct NormalTextField: ViewModifier {

	var image: UIImage
	var colorStyle: IColorSet = ColorSet()
	var fontStyle: IFontSet = DefaultFontSet()
	var imageStyle: IAppImageSet = AppImageSet()
	@Binding var focused: Bool
	@Environment(\.colorScheme) var colorScheme

	public func body(content: Content) -> some View {
		HStack {
			Image(uiImage: image)
				.foregroundColor(colorScheme == .light ? Color(colorStyle.gray3) : Color(colorStyle.gray3Dark))
				.padding(.leading)
			content
				.font(Font(fontStyle.font(style: .textS)))
				.foregroundColor(colorScheme == .light ? Color(colorStyle.gray3) : Color(colorStyle.gray3Dark))
				.padding(.leading, 10)
		}
		.frame(width: UIScreen.main.bounds.width - 30, height: 52)
		.background(colorScheme == .light ? Color(colorStyle.gray5) : Color(colorStyle.gray5Dark))
		.cornerRadius(16)
		.overlay(RoundedRectangle(cornerRadius: 16)
					.stroke(colorScheme == .light ? (focused ? Color(colorStyle.black) : Color(colorStyle.gray5)) : (focused ? Color(colorStyle.gray3Dark) : Color(colorStyle.gray5Dark)), lineWidth: 2))
	}
}

struct PasswordTextField: ViewModifier {

	var image: UIImage
	var colorStyle: IColorSet = ColorSet()
	var fontStyle: IFontSet = DefaultFontSet()
	var imageStyle: IAppImageSet = AppImageSet()
	@Binding var focused: Bool
	@Environment(\.colorScheme) var colorScheme

	func body(content: Content) -> some View {
		HStack {
			Image(uiImage: image)
				.padding(.leading)
				.foregroundColor(colorScheme == .light ? Color(colorStyle.gray1) : Color(colorStyle.gray3Dark))
			content
				.font(Font(fontStyle.font(style: .textS)))
				.foregroundColor(colorScheme == .light ? Color(colorStyle.gray1) : Color(colorStyle.gray3Dark))
				.padding(.leading, 10)
			Image(uiImage: imageStyle.eyeIcon)
				.padding(.trailing)
		}
		.frame(width: UIScreen.main.bounds.width - 30, height: 52)
		.background(colorScheme == .light ? Color(colorStyle.gray5) : Color(colorStyle.gray5Dark))
		.cornerRadius(16)
		.overlay(RoundedRectangle(cornerRadius: 16)
					.stroke(colorScheme == .light ? (focused ? Color(colorStyle.black) : Color(colorStyle.gray5)) : (focused ? Color(colorStyle.gray3Dark) : Color(colorStyle.gray5Dark)), lineWidth: 2))
	}
}

struct PasswordTextFieldError: ViewModifier {

	var image: UIImage
	var colorStyle: IColorSet = ColorSet()
	var fontStyle: IFontSet = DefaultFontSet()
	var imageStyle: IAppImageSet = AppImageSet()
	@Binding var focused: Bool
	@Environment(\.colorScheme) var colorScheme

	func body(content: Content) -> some View {
		HStack {
			Image(uiImage: image)
				.padding(.leading)
				.foregroundColor(colorScheme == .light ? Color(colorStyle.gray3Dark) : Color(colorStyle.gray3Dark))
			content
				.font(Font(fontStyle.font(style: .textS)))
				.foregroundColor(colorScheme == .light ? Color(colorStyle.gray3Dark) : Color(colorStyle.gray3Dark))
				.padding(.leading, 10)
			Button(action: {
					  print("button pressed")

					}) {
						Image(uiImage: imageStyle.eyeIcon)
					}
		}
		.frame(width: UIScreen.main.bounds.width - 30, height: 52)
		.background(colorScheme == .light ? Color(colorStyle.errorLight) : Color(colorStyle.gray5Dark))
		.cornerRadius(16)
		.overlay(RoundedRectangle(cornerRadius: 16)
					.stroke(colorScheme == .light ? (focused ? Color(colorStyle.errorDark) : Color(colorStyle.errorLight)) : (focused ? Color(colorStyle.primary) : Color(colorStyle.gray5Dark)), lineWidth: 2))
	}
}

