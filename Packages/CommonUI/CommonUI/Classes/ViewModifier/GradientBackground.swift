//
//  GradientBackground.swift
//  ClearKeep
//
//  Created by NamNH on 4/12/21.
//

import SwiftUI

struct GradientBackground: ViewModifier {
	var colors: [Color]
	
	public func body(content: Content) -> some View {
		ZStack(alignment: .topLeading) {
			LinearGradient(gradient: Gradient(colors: colors), startPoint: .leading, endPoint: .trailing)
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

extension View {
	func grandientBackground(colors: [Color]) -> some View {
		self.modifier(GradientBackground(colors: colors))
	}
	
	func gradientHeader(opacity: Double = 1.0, colors: [Color]) -> some View {
		ZStack(alignment: .center) {
			self.background(LinearGradient(gradient: Gradient(colors: colors), startPoint: .leading, endPoint: .trailing).opacity(opacity))
		}
	}
}
