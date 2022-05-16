//
//  LinkButton.swift
//  CommonUI
//
//  Created by NamNH on 09/05/2022.
//

import SwiftUI

private enum Constants {
	static let spacing = 16.0
}

public struct LinkButton: View {
	// MARK: - Variables
	private let title: String
	private let icon: Image?
	private let alignment: Alignment
	private var action: () -> Void
	
	// MARK: Init
	public init(_ title: String, icon: Image? = nil, alignment: Alignment, action: @escaping() -> Void) {
		self.title = title
		self.icon = icon
		self.alignment = alignment
		self.action = action
	}
	
	// MARK: - Body
	public var body: some View {
		Button(action: action,
			   label: {
			HStack(spacing: Constants.spacing) {
				if let icon = icon {
					icon
						.renderingMode(.template)
				}
				Text(title)
				 .font(commonUIConfig.fontSet.font(style: .body3))
			}
			.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: alignment)
		})
		.font(commonUIConfig.fontSet.font(style: .body3))
		.frame(maxWidth: .infinity, maxHeight: .infinity)
	}
}
