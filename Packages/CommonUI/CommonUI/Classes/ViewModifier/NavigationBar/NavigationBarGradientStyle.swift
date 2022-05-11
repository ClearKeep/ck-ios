//
//  NavigationBarGradientStyle.swift
//  CommonUI
//
//  Created by NamNH on 09/05/2022.
//

import SwiftUI

struct NavigationBarGradidentStyle<L, R>: ViewModifier where L: View, R: View {
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
				.padding([.horizontal, .bottom], 16)
				
				if let title = title {
					Text(title)
						.font(commonUIConfig.fontSet.font(style: .body2))
						.foregroundColor(commonUIConfig.colorSet.black)
						.padding(.top, 23)
				}
			}
			.background(backgroundColor)
			
			content
		}
		.hiddenNavigationBarStyle()
		.edgesIgnoringSafeArea(.top)
	}
}

// MARK: - Private
extension NavigationBarGradidentStyle {
	var backgroundColor: LinearGradient {
		colorScheme == .light
		? LinearGradient(gradient: Gradient(colors: commonUIConfig.colorSet.gradientPrimary), startPoint: .leading, endPoint: .trailing)
		: LinearGradient(gradient: Gradient(colors: [commonUIConfig.colorSet.darkGrey2]), startPoint: .leading, endPoint: .trailing)
	}
}

public extension View {
	func applyNavigationBarGradidentStyle<L, R>(title: String? = nil, leftBarItems: @escaping (() -> L), rightBarItems: @escaping (() -> R)) -> some View where L: View, R: View {
		self.modifier(NavigationBarGradidentStyle(title: title, leftBarItems: leftBarItems, rightBarItems: rightBarItems))
	}
}
