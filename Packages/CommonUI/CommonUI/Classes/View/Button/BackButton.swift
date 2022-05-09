//
//  BackButton.swift
//  CommonUI
//
//  Created by NamNH on 09/05/2022.
//

import SwiftUI

private enum Constants {
	static let buttonSize = CGSize(width: 40.0, height: 40.0)
}

public struct BackButton: View {
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
			commonUIConfig.imageSet.backIcon
				.resizable()
				.aspectRatio(contentMode: .fit)
				.frame(width: Constants.buttonSize.width, height: Constants.buttonSize.height)
				.foregroundColor(foregroundColor)
		}
	}
}

// MARK: - Private
private extension BackButton {
	var foregroundColor: Color {
		colorScheme == .light ? commonUIConfig.colorSet.offWhite : commonUIConfig.colorSet.grey3
	}
}
