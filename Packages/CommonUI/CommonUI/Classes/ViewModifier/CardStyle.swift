//
//  CardStyle.swift
//  CommonUI
//
//  Created by NamNH on 06/05/2022.
//

import SwiftUI

private enum Constants {
	static let cornerRadius = 32.0
}

struct CardStyle: ViewModifier {
	var backgroundColor: Color

	func body(content: Content) -> some View {
		content
			.background(RoundedRectangle(cornerRadius: Constants.cornerRadius).fill(backgroundColor))
	}
}

extension View {
	public func applyCardViewStyle(backgroundColor: Color) -> some View {
		ModifiedContent(content: self, modifier: CardStyle(backgroundColor: backgroundColor))
	}
}
