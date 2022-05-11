//
//  RoundedButton.swift
//  CommonUI
//
//  Created by NamNH on 09/05/2022.
//

import SwiftUI

private enum Constants {
	static let radiusButton = 40.0
	static let buttonHeight = 40.0
}

public struct RoundedButton: View {
	// MARK: - Variables
	@Environment(\.colorScheme) var colorScheme
	
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
		.foregroundColor(disabled ? foregroundColorUnActive : foregroundColorActive)
		.cornerRadius(Constants.radiusButton)
		.frame(height: Constants.buttonHeight)
		.frame(maxWidth: .infinity)
	}
}

// MARK: - Private
private extension RoundedButton {
	var foregroundColorActive: Color {
		colorScheme == .light ? commonUIConfig.colorSet.primaryDefault : commonUIConfig.colorSet.offWhite
	}

	var foregroundColorUnActive: Color {
		colorScheme == .light ? commonUIConfig.colorSet.primaryDefault.opacity(0.5) : commonUIConfig.colorSet.offWhite.opacity(0.5)
	}

	var backgroundColorActive: LinearGradient {
		if colorScheme == .light {
			return LinearGradient(gradient: Gradient(colors: [commonUIConfig.colorSet.offWhite]), startPoint: .leading, endPoint: .trailing)
		} else {
			return LinearGradient(gradient: Gradient(colors: commonUIConfig.colorSet.gradientLinear), startPoint: .leading, endPoint: .trailing)
		}
	}
	
	var backgroundColorUnActive: LinearGradient {
		if colorScheme == .light {
			return LinearGradient(gradient: Gradient(colors: [commonUIConfig.colorSet.offWhite].compactMap({ $0.opacity(0.5) })), startPoint: .leading, endPoint: .trailing)
		} else {
			return LinearGradient(gradient: Gradient(colors: commonUIConfig.colorSet.gradientLinear.compactMap({ $0.opacity(0.5) })), startPoint: .leading, endPoint: .trailing)
		}
	}
}
