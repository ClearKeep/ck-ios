//
//  MessageTextViewModifier.swift
//  
//
//  Created by NamNH on 20/03/2022.
//

import SwiftUI

private enum Constants {
	static let paddingVertical = 12.0
	static let paddingHorizontal = 24.0
}

struct MessageTextViewModifier: ViewModifier {
	// MARK: - Body
	func body(content: Content) -> some View {
		content
			.padding(.vertical, Constants.paddingVertical)
			.padding(.horizontal, Constants.paddingHorizontal)
			.background(commonUIConfig.colorSet.primaryDefault)
			.font(commonUIConfig.fontSet.font(style: .input2))
			.foregroundColor(commonUIConfig.colorSet.offWhite)
			.lineSpacing(10)
	}
}
