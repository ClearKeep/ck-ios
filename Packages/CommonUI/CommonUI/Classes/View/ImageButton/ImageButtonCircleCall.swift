//
//  ImageButtonCircleCall.swift
//  CommonUI
//
//  Created by MinhDev on 27/06/2022.
//

import SwiftUI

private enum Constants {
	static let textHeight = 24.0
	static let spacing = 14.0
	static let paddingHorizontal = 24.0
	static let sizeIconCall = 16.0
	static let sizeBoder = 36.0
	static let lineBoder = 2.0
}

public struct ImageButtonCircleCall: View {
	// MARK: - Variables
	@Environment(\.colorScheme) var colorScheme
	private let image: Image
	private var title: String
	private var action: () -> Void
	
	// MARK: - Init
	public init(_ title: String, image: Image, action: @escaping() -> Void) {
		self.title = title
		self.action = action
		self.image = image
	}

	// MARK: - Body
	public var body: some View {
		Button(action: action) {
			VStack {
				ZStack {
					image
						.renderingMode(.template)
						.resizable()
						.foregroundColor(foregroundButton)
						.frame(width: Constants.sizeIconCall, height: Constants.sizeIconCall)
					Circle()
						.strokeBorder(foregroundButton, lineWidth: Constants.lineBoder)
						.frame(width: Constants.sizeBoder, height: Constants.sizeBoder)
				}
				Text(title)
					.font(commonUIConfig.fontSet.font(style: .body2))
					.foregroundColor(foregroundButton)
			}
		}
	}
}

private extension ImageButtonCircleCall {
	var foregroundButton: Color {
		colorScheme == .light ? commonUIConfig.colorSet.primaryDefault : commonUIConfig.colorSet.primaryDefault
	}
}
