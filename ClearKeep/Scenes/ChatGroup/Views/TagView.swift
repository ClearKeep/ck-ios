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
			HStack {
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
		.frame(alignment: .leading)
		.frame(height: Constants.heightTagUser)
	}
}

// MARK: - Private Variables
private extension TagView {
	var backgroundTagUser: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.grey5 : AppTheme.shared.colorSet.primaryDefault
	}

	var foregroundTagUser: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.grey2 : AppTheme.shared.colorSet.greyLight
	}

	var foregroundCrossIcon: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.black : AppTheme.shared.colorSet.greyLight
	}
}
