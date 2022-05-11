//
//  NavigationBarStyle.swift
//  ClearKeep
//
//  Created by NamNH on 4/19/21.
//

import SwiftUI
import Introspect

func globalSafeAreaInsets() -> UIEdgeInsets {
	return UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.safeAreaInsets ?? UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
}

struct NavigationBarPlainStyle<L, R>: ViewModifier where L: View, R: View {
	// MARK: - Variables
	@Environment(\.colorScheme) var colorScheme
	var title: String
	var titleFont: Font
	var titleColor: Color
	var backgroundColors: [Color]?
	var leftBarItems: (() -> L)?
	var rightBarItems: (() -> R)?
	
	func body(content: Content) -> some View {
		VStack(alignment: .leading) {
			HStack {
				leftBarItems?()
					.padding(.trailing, 8)
				Text(title)
					.font(titleFont)
					.foregroundColor(titleColor)
				Spacer()
				rightBarItems?()
			}
			.padding(.top, globalSafeAreaInsets().top)
			.padding(16.0)
			.gradientHeader(colors: headerBackgroundColor)
			.frame(width: UIScreen.main.bounds.width, height: 60 + globalSafeAreaInsets().top)
			content
		}
		.hiddenNavigationBarStyle()
		.edgesIgnoringSafeArea(.top)
	}
	
	private var headerBackgroundColor: [Color] {
		if let backgroundColors = backgroundColors {
			return backgroundColors
		} else {
			return colorScheme == .light ? commonUIConfig.colorSet.gradientPrimary : commonUIConfig.colorSet.gradientBlack
		}
	}
}

public extension View {
	func applyNavigationBarPlainStyle<L, R>(title: String, titleColor: Color, backgroundColors: [Color]? = nil, leftBarItems: @escaping (() -> L), rightBarItems: @escaping (() -> R)) -> some View where L: View, R: View {
		self.modifier(NavigationBarPlainStyle(title: title, titleFont: commonUIConfig.fontSet.font(style: .body2), titleColor: titleColor, backgroundColors: backgroundColors, leftBarItems: leftBarItems, rightBarItems: rightBarItems))
	}
}
