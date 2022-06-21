//
//  ReverseViewModifier.swift
//  CommonUI
//
//  Created by Quang Pham on 15/06/2022.
//

import SwiftUI

struct FlippedUpsideDown: ViewModifier {
	func body(content: Content) -> some View {
		content
			.rotationEffect(.radians(Double.pi))
			.scaleEffect(x: -1, y: 1, anchor: .center)
	}
}

extension View {
	func flippedUpsideDown() -> some View {
		modifier(FlippedUpsideDown())
	}
}
