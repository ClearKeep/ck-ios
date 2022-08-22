//
//  ToggleCustom.swift
//  CommonUI
//
//  Created by MinhDev on 19/08/2022.
//

import Foundation
import SwiftUI

private enum Constants {
	static let textHeight = 24.0
	static let spacing = 14.0
	static let paddingHorizontal = 24.0
}

public struct ToggleCustom: View {
	// MARK: - Variables
	@Environment(\.colorScheme) private var colorScheme
	@Binding var isChecked: Bool
	private let text: String
	private let action: (() -> Void)?

	// MARK: - Init
	public init(text: String, isChecked: Binding<Bool>, action: (() -> Void)? = nil) {
		self.text = text
		self._isChecked = isChecked
		self.action = action
	}

	// MARK: - Body
	public var body: some View {
		Toggle(isOn: $isChecked, label: {
			Text(text)
				.font(commonUIConfig.fontSet.font(style: .placeholder1))
				.frame(height: Constants.textHeight)
				.foregroundColor(foregroundShowPreviewTitle)
		})
		.toggleStyle(SwitchToggleStyle(tint: commonUIConfig.colorSet.primaryDefault))
	}
}

// MARK: - Private func
private extension ToggleCustom {

	var foregroundShowPreviewTitle: Color {
		colorScheme == .light ? commonUIConfig.colorSet.black : commonUIConfig.colorSet.primaryDefault
	}
}

struct ToggleCustom_Previews: PreviewProvider {
	static var previews: some View {
		ToggleCustom(text: ("Test"), isChecked: .constant(false))
	}
}
