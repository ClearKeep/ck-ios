//
//  RoundedBorderButton.swift
//  CommonUI
//
//  Created by NamNH on 09/05/2022.
//

import SwiftUI

private enum Constants {
	static let radiusButton = 40.0
	static let buttonHeight = 40.0
}

public struct RoundedBorderButton: View {
	// MARK: - Variables
	@Environment(\.colorScheme) var colorScheme
	
	@Binding var disable: Bool
	private var title: String
	private var action: () -> Void
	
	// MARK: Init
	public init(_ title: String, disable: Binding<Bool> = .constant(false), action: @escaping() -> Void) {
		self.title = title
		self.action = action
		self._disable = disable
	}
	
	// MARK: - Body
	public var body: some View {
		Button(action: action) {
			Text(title)
				.font(commonUIConfig.fontSet.font(style: .body3))
				.frame(maxWidth: .infinity, maxHeight: .infinity)
		}
		.disabled(disable)
		.background(disable ? backgroundColorUnActive : backgroundColorActive)
		.foregroundColor(disable ? foregroundColorUnActive : foregroundColorActive)
		.cornerRadius(Constants.radiusButton)
		.frame(height: Constants.buttonHeight)
		.frame(maxWidth: .infinity)
		.applyBorderStyle()
	}
}

// MARK: - Private
private extension RoundedBorderButton {
	var foregroundColorActive: Color {
		colorScheme == .light ? commonUIConfig.colorSet.offWhite : commonUIConfig.colorSet.primaryDefault
	}

	var foregroundColorUnActive: Color {
		colorScheme == .light ? commonUIConfig.colorSet.offWhite.opacity(0.5) : commonUIConfig.colorSet.primaryDefault.opacity(0.5)
	}

	var backgroundColorActive: LinearGradient {
		if colorScheme == .light {
			return LinearGradient(gradient: Gradient(colors: commonUIConfig.colorSet.gradientPrimary), startPoint: .leading, endPoint: .trailing)
		} else {
			return LinearGradient(gradient: Gradient(colors: commonUIConfig.colorSet.gradientBlack), startPoint: .leading, endPoint: .trailing)
		}
	}
	
	var backgroundColorUnActive: LinearGradient {
		if colorScheme == .light {
			return LinearGradient(gradient: Gradient(colors: commonUIConfig.colorSet.gradientPrimary.compactMap({ $0.opacity(0.5) })), startPoint: .leading, endPoint: .trailing)
		} else {
			return LinearGradient(gradient: Gradient(colors: commonUIConfig.colorSet.gradientBlack.compactMap({ $0.opacity(0.5) })), startPoint: .leading, endPoint: .trailing)
		}
	}
}
