//
//  RoundedGradientButton.swift
//  CommonUI
//
//  Created by NamNH on 06/05/2022.
//

import SwiftUI

private enum Constants {
	static let radiusButton = 40.0
}

public struct RoundedGradientButton: View {
	// MARK: - Variables
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
				.frame(maxWidth: .infinity, maxHeight: .infinity)
		}
		.disabled(disable)
		.background(disable ? backgroundColorActive : backgroundColorUnActive)
		.foregroundColor(disable ? commonUIConfig.colorSet.offWhite.opacity(0.5) : commonUIConfig.colorSet.offWhite)
		.cornerRadius(Constants.radiusButton)
		.frame(maxWidth: .infinity, maxHeight: .infinity)
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
