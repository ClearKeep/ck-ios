//
//  LinkButton.swift
//  CommonUI
//
//  Created by NamNH on 09/05/2022.
//

import SwiftUI

public struct LinkButton: View {
	// MARK: - Variables
	@Environment(\.colorScheme) var colorScheme
	
	private let title: String
	private let alignment: Alignment
	private var action: () -> Void
	
	// MARK: Init
	public init(_ title: String, alignment: Alignment, action: @escaping() -> Void) {
		self.title = title
		self.alignment = alignment
		self.action = action
	}
	
	// MARK: - Body
	public var body: some View {
		Button(action: action,
			   label: {
			Text(title)
				.font(commonUIConfig.fontSet.font(style: .body3))
				.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: alignment)
		})
		.font(commonUIConfig.fontSet.font(style: .body3))
		.foregroundColor(foregroundColor)
		.frame(maxWidth: .infinity, maxHeight: .infinity)
	}
}

// MARK: - Private
private extension LinkButton {
	var foregroundColor: Color {
		colorScheme == .light ? commonUIConfig.colorSet.offWhite : commonUIConfig.colorSet.primaryDefault
	}
}
