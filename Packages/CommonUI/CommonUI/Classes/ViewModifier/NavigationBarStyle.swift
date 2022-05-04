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

struct NavigationBarGradidentStyle<L, R>: ViewModifier where L: View, R: View {
	var title: String?
	var leftBarItems: (() -> L)?
	var rightBarItems: (() -> R)?
	
	func body(content: Content) -> some View {
		VStack(alignment: .leading) {
			Spacer()
				.grandientBackground(colors: commonUIConfig.colorSet.gradientPrimary)
				.frame(width: UIScreen.main.bounds.width, height: 20 + globalSafeAreaInsets().top)
			
			VStack(alignment: .leading) {
				HStack {
					leftBarItems?()
					Spacer()
					rightBarItems?()
				}
				.padding(.top, 29)
				
				if let title = title {
					Text(title)
						.font(commonUIConfig.fontSet.font(style: .body2))
						.foregroundColor(commonUIConfig.colorSet.black)
						.padding(.top, 23)
				}
			}
			.padding([.bottom, .horizontal], 16)
			
			content
		}
		.navigationBarHidden(true)
		.navigationBarTitle("", displayMode: .inline)
		.navigationBarBackButtonHidden(true)
		.edgesIgnoringSafeArea(.top)
	}
}

struct NavigationBarPlainStyle<L, R>: ViewModifier where L: View, R: View {
	var title: String
	var titleFont: Font
	var titleColor: Color
	var backgroundColors: [Color]
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
			.padding(16)
			.gradientHeader(colors: backgroundColors)
			.frame(width: UIScreen.main.bounds.width, height: 60 + globalSafeAreaInsets().top)
			content
		}
		.navigationBarHidden(true)
		.navigationBarTitle("", displayMode: .inline)
		.navigationBarBackButtonHidden(true)
		.edgesIgnoringSafeArea(.top)
	}
}

public extension View {
	func applyNavigationBarGradidentStyle<L, R>(title: String? = nil, leftBarItems: @escaping (() -> L), rightBarItems: @escaping (() -> R)) -> some View where L: View, R: View {
		self.modifier(NavigationBarGradidentStyle(title: title, leftBarItems: leftBarItems, rightBarItems: rightBarItems))
	}
	
	func applyNavigationBarPlainStyle<L, R>(title: String, titleColor: Color, backgroundColors: [Color], leftBarItems: @escaping (() -> L), rightBarItems: @escaping (() -> R)) -> some View where L: View, R: View {
		self.modifier(NavigationBarPlainStyle(title: title, titleFont: commonUIConfig.fontSet.font(style: .body2), titleColor: commonUIConfig.colorSet.black, backgroundColors: backgroundColors, leftBarItems: leftBarItems, rightBarItems: rightBarItems))
	}
}
