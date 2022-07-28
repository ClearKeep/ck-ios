//
//  NavigationGradientPlainStyle.swift
//  CommonUI
//
//  Created by MinhDev on 05/07/2022.
//

import SwiftUI

struct NavigationGradientPlainStyle<L, R>: ViewModifier where L: View, R: View {
	// MARK: - Variables
	@Environment(\.colorScheme) var colorScheme
	var title: String?
	var leftBarItems: (() -> L)?
	var rightBarItems: (() -> R)?

	// MARK: - Body
	func body(content: Content) -> some View {
		VStack(alignment: .leading, spacing: 0) {
			Spacer()
				.frame(width: UIScreen.main.bounds.width, height: 20 + globalSafeAreaInsets().top)
				.background(backgroundColor)

			VStack(alignment: .leading, spacing: 0) {
				HStack {
					leftBarItems?()
					Spacer()
					rightBarItems?()
				}
				.padding(.top, 29.25)
				.padding(.horizontal, 16)

				if let title = title {
					Text(title)
						.font(commonUIConfig.fontSet.font(style: .body2))
						.foregroundColor(commonUIConfig.colorSet.black)
						.padding(.horizontal, 16)
						.padding(.top, 20)
				}
			}

			content
		}
		.hiddenNavigationBarStyle()
		.edgesIgnoringSafeArea(.top)
	}
}

// MARK: - Private
extension NavigationGradientPlainStyle {
	var backgroundColor: LinearGradient {
		colorScheme == .light
		? LinearGradient(gradient: Gradient(colors: commonUIConfig.colorSet.gradientPrimary), startPoint: .leading, endPoint: .trailing)
		: LinearGradient(gradient: Gradient(colors: [commonUIConfig.colorSet.darkGrey2]), startPoint: .leading, endPoint: .trailing)
	}
}

public extension View {
	func applyNavigationGradientPlainStyle<L, R>(title: String? = nil, leftBarItems: @escaping (() -> L), rightBarItems: @escaping (() -> R)) -> some View where L: View, R: View {
		self.modifier(NavigationGradientPlainStyle(title: title, leftBarItems: leftBarItems, rightBarItems: rightBarItems))
	}
}
