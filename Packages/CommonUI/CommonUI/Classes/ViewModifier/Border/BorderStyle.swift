//
//  BorderStyle.swift
//  CommonUI
//
//  Created by NamNH on 09/05/2022.
//

import SwiftUI

private enum Constants {
	static let cornerRadius = 40.0
	static let lineWidth = 2.0
}

struct BorderStyle: ViewModifier {
	// MARK: - Variables
	@Environment(\.colorScheme) var colorScheme
	
	func body(content: Content) -> some View {
		content
			.overlay(RoundedRectangle(cornerRadius: Constants.cornerRadius)
				.stroke(borderColor, lineWidth: Constants.lineWidth))
	}
}

// MARK: - Private
extension BorderStyle {
	var borderColor: Color {
		colorScheme == .light ? commonUIConfig.colorSet.offWhite : commonUIConfig.colorSet.primaryDefault
	}
}

extension View {
	public func applyBorderStyle() -> some View {
		ModifiedContent(content: self, modifier: BorderStyle())
	}
}
