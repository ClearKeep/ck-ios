//
//  BackButtonBar.swift
//  ChatSecure
//
//  Created by MinhDev on 13/06/2022.
//

import SwiftUI

private enum Constants {
	static let buttonSize = CGSize(width: 16.0, height: 28.0)
}

public struct BackButtonStandard: View {
	// MARK: - Variables
	@Environment(\.colorScheme) var colorScheme

	private var action: () -> Void

	// MARK: Init
	public init(_ action: @escaping() -> Void) {
		self.action = action
	}

	// MARK: - Body
	public var body: some View {
		Button(action: action) {
			commonUIConfig.imageSet.chevleftIcon
				.resizable()
				.aspectRatio(contentMode: .fit)
				.frame(width: Constants.buttonSize.width, height: Constants.buttonSize.height)
				.foregroundColor(foregroundColor)
		}
	}
}

// MARK: - Private
private extension BackButtonStandard {
	var foregroundColor: Color {
		colorScheme == .light ? commonUIConfig.colorSet.grey1 : commonUIConfig.colorSet.greyLight
	}
}
