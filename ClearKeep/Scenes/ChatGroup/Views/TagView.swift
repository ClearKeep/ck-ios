//
//  FlexibleView.swift
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

struct TagView: View {
	// MARK: - Variables
	@State private(set) var groupChatModel: [GroupChatModel]
	@Environment(\.colorScheme) var colorScheme
	@Environment(\.injected) private var injected: DIContainer

	// MARK: - Init
	init(groupChatModel: [GroupChatModel]) {
		self._groupChatModel = .init(initialValue: groupChatModel)
	}

	// MARK: - Body
	var body: some View {
		ScrollView(.horizontal, showsIndicators: false) {
			HStack(spacing: 10) {
				ForEach(0..<groupChatModel.count, id: \.self) { index in
					tagView(for: groupChatModel[index].name)
				}
			}
		}
	}

	private func tagView(for text: String) -> some View {
		HStack {
			Text(text)
				.font(AppTheme.shared.fontSet.font(style: .body3))
				.foregroundColor(foregroundTagUser)
				.padding([.leading, .top, .bottom], Constants.paddingTagUser)

			Button(action: {

			}, label: {
				Button {

				} label: {
					AppTheme.shared.imageSet.crossIcon
						.foregroundColor(foregroundCrossIcon)
						.padding(.trailing, Constants.paddingTagUser)
				}
			})
		}
		.background(backgroundTagUser)
		.cornerRadius(Constants.cornerRadiusTagUser)
		.frame(maxWidth: .infinity, alignment: .leading)
		.frame(height: Constants.heightTagUser)
	}
}

// MARK: - Private Variables
private extension TagView {
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
}
