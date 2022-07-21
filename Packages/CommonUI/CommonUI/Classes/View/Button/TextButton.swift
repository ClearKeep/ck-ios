//
//  TextButton.swift
//  CommonUI
//
//  Created by MinhDev on 04/07/2022.
//

import SwiftUI

private enum Constants {
	static let spacing = 16.0
}

public struct TextButton: View {
	// MARK: - Variables
	private let title: String
	private var action: () -> Void

	// MARK: Init
	public init(_ title: String, action: @escaping() -> Void) {
		self.title = title
		self.action = action
	}

	// MARK: - Body
	public var body: some View {
		Button(action: action,
			   label: {
				Text(title)
				 .font(commonUIConfig.fontSet.font(style: .body3))
		})
		.font(commonUIConfig.fontSet.font(style: .body3))
	}
}
