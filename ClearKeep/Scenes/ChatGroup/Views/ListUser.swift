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
	static let spacing = 10.0
	static let padding = 20.0
	static let sizeImage = 64.0
	static let radius = 8.0
	static let heightButton = 30.0
	static let boder = 2.0
	static let paddingTagUser = 8.0
	static let cornerRadiusTagUser = 80.0
	static let heightTagUser = 40.0
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
	var foregroundColorText: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.grey2 : AppTheme.shared.colorSet.greyLight
	}

	var foregroundColorSelect: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.primaryDefault : AppTheme.shared.colorSet.greyLight2
	}

	var backgroundButton: LinearGradient {
		colorScheme == .light ? backgroundButtonLight : backgroundButtonDark
	}

	var backgroundButtonDark: LinearGradient {
		LinearGradient(gradient: Gradient(colors: AppTheme.shared.colorSet.gradientPrimary), startPoint: .leading, endPoint: .trailing)
	}

	var backgroundTagUser: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.grey5 : AppTheme.shared.colorSet.primaryDefault
	}

	var backgroundButtonLight: LinearGradient {
		LinearGradient(gradient: Gradient(colors: [AppTheme.shared.colorSet.offWhite, AppTheme.shared.colorSet.offWhite]), startPoint: .leading, endPoint: .trailing)
	}

	var foregroundTagUser: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.grey2 : AppTheme.shared.colorSet.greyLight
	}

	var foregroundCrossIcon: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.black : AppTheme.shared.colorSet.greyLight
	}

	var backgroundGradientPrimary: LinearGradient {
		LinearGradient(gradient: Gradient(colors: AppTheme.shared.colorSet.gradientPrimary), startPoint: .leading, endPoint: .trailing)
	}
}
