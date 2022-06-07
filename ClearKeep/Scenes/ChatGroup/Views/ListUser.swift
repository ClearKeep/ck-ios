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
	@Environment(\.colorScheme) var colorScheme
	@Environment(\.injected) private var injected: DIContainer
	var userModel: GroupChatModel
	@ObservedObject var groupData: GroupChatData

	// MARK: - Body
	var body: some View {
			HStack {
				ZStack {
					Circle()
						.fill(backgroundGradientPrimary)
						.frame(width: Constants.sizeImage, height: Constants.sizeImage)
					AppTheme.shared.imageSet.userIcon
				}
				Text(userModel.name)
					.frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
					.font(AppTheme.shared.fontSet.font(style: .input2))
					.foregroundColor(foregroundTagUser)

				Button(action: {
					selectedCheckbox.toggle()
					groupData.setCheckItem(model: userModel, isChecked: selectedCheckbox)
				}, label: {
					checkMaskIcon
						.foregroundColor(focegroundColorImage)
				})
			}.onAppear {
				selectedCheckbox = userModel.checked
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

	var focegroundColorImage: Color {
		selectedCheckbox ? AppTheme.shared.colorSet.primaryDark : AppTheme.shared.colorSet.grey3
	}

	var font: Font {
		AppTheme.shared.fontSet.font(style: .body3)
	}

	var checkMaskIcon: Image {
		selectedCheckbox ? AppTheme.shared.imageSet.checkedIcon : AppTheme.shared.imageSet.unCheckIcon
	}
}
