//
//  RoundedGradientButton.swift
//  CommonUI
//
//  Created by NamNH on 06/05/2022.
//

import SwiftUI

private enum Constants {
	static let radiusButton = 40.0
	static let buttonHeight = 40.0
}

public struct RoundedGradientButton: View {
	// MARK: - Variables
	@Binding var disabled: Bool
	private var title: String
	private var action: () -> Void
	
	// MARK: Init
	public init(_ title: String, disabled: Binding<Bool> = .constant(false), action: @escaping() -> Void) {
		self.title = title
		self.action = action
		self._disabled = disabled
	}
	
	// MARK: - Body
	public var body: some View {
		Button(action: action) {
			Text(title)
				.font(commonUIConfig.fontSet.font(style: .body3))
				.frame(maxWidth: .infinity, maxHeight: .infinity)
		}
		.disabled(disabled)
		.background(disabled ? backgroundColorUnActive : backgroundColorActive)
		.foregroundColor(disabled ? commonUIConfig.colorSet.offWhite.opacity(0.5) : commonUIConfig.colorSet.offWhite)
		.cornerRadius(Constants.radiusButton)
		.frame(height: Constants.buttonHeight)
		.frame(maxWidth: .infinity)
	}
}

// MARK: - Private
private extension RoundedGradientButton {
	var backgroundColorActive: LinearGradient {
		LinearGradient(gradient: Gradient(colors: commonUIConfig.colorSet.gradientLinear), startPoint: .leading, endPoint: .trailing)
	}
	
	var backgroundColorUnActive: LinearGradient {
		LinearGradient(gradient: Gradient(colors: commonUIConfig.colorSet.gradientLinear.compactMap({ $0.opacity(0.5) })), startPoint: .leading, endPoint: .trailing)
	}
}
