//
//  ListUser.swift
//  ClearKeep
//
//  Created by đông on 19/04/2022.
//

import SwiftUI
import Common
import CommonUI

private enum Constants {
	static let sizeImage = 64.0
}

struct ListUser: View {
	// MARK: - Variables
	@State private var selectedCheckbox: Bool = false
	@Binding var name: String
	@Environment(\.colorScheme) var colorScheme
	@Environment(\.injected) private var injected: DIContainer

	// MARK: - Init
	init(name: Binding<String>) {
		self._name = name
	}

	// MARK: - Body
	var body: some View {
			HStack {
				ZStack {
					Circle()
						.fill(backgroundGradientPrimary)
						.frame(width: Constants.sizeImage, height: Constants.sizeImage)
					AppTheme.shared.imageSet.userIcon
				}
				Text(name)
					.frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
					.font(AppTheme.shared.fontSet.font(style: .input2))
					.foregroundColor(foregroundTagUser)
				CheckBoxButtons(text: "", isChecked: $selectedCheckbox)
			}
	}
}

// MARK: - Private Variables
private extension ListUser {

	var foregroundTagUser: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.grey2 : AppTheme.shared.colorSet.greyLight
	}

	var backgroundGradientPrimary: LinearGradient {
		LinearGradient(gradient: Gradient(colors: AppTheme.shared.colorSet.gradientPrimary), startPoint: .leading, endPoint: .trailing)
	}
}
