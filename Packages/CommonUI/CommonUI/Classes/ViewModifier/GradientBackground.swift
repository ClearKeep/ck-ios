//
//  GradientBackground.swift
//  ClearKeep
//
//  Created by NamNH on 4/12/21.
//

import SwiftUI

struct GradientBackground: ViewModifier {
	// MARK: - Variables
	@Environment(\.colorScheme) var colorScheme
	
	// MARK: - Body
	func body(content: Content) -> some View {
		ZStack(alignment: .topLeading) {
			backgroundColor
				.frame(minWidth: 0,
					   maxWidth: .infinity,
					   minHeight: 0,
					   maxHeight: .infinity,
					   alignment: .topLeading
				)
			content
		}
		.edgesIgnoringSafeArea(.bottom)
	}
}

// MARK: Private
extension GradientBackground {
	var backgroundColor: LinearGradient {
		colorScheme == .light ? backgroundColorLight : backgroundColorDark
	}

	var backgroundColorDark: LinearGradient {
		LinearGradient(gradient: Gradient(colors: commonUIConfig.colorSet.gradientBlack), startPoint: .leading, endPoint: .trailing)
	}

	var backgroundColorLight: LinearGradient {
		LinearGradient(gradient: Gradient(colors: commonUIConfig.colorSet.gradientPrimary), startPoint: .leading, endPoint: .trailing)
	}

}

public extension View {
	func grandientBackground() -> some View {
		self.modifier(GradientBackground())
	}
	
	func gradientHeader(opacity: Double = 1.0, colors: [Color]) -> some View {
		ZStack(alignment: .center) {
			self.background(LinearGradient(gradient: Gradient(colors: colors), startPoint: .leading, endPoint: .trailing).opacity(opacity))
		}
	}
}
