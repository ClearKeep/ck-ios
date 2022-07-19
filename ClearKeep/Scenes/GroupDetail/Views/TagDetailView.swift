//
//  TagDetailView.swift
//  ClearKeep
//
//  Created by MinhDev on 18/07/2022.
//

import SwiftUI
import Common
import CommonUI

private enum Constants {
	static let paddingTagUser = 8.0
	static let cornerRadiusTagUser = 80.0
	static let heightTagUser = 40.0
	static let sizeIcon = CGSize(width: 27.0, height: 27.0)
}

struct TagDetailView: View {
	// MARK: - Variables
	@Binding var groupDetaiModel: [GroupDetailUserViewModels]
	@Environment(\.colorScheme) var colorScheme
	@Environment(\.injected) private var injected: DIContainer
	var deleteSelect: (GroupDetailUserViewModels) -> Void

	init(groupDetaiModel: Binding<[GroupDetailUserViewModels]>, deleteSelect: @escaping (GroupDetailUserViewModels) -> Void) {
		_groupDetaiModel = groupDetaiModel
		self.deleteSelect = deleteSelect
	}

	// MARK: - Body
	var body: some View {
		ScrollView(.horizontal, showsIndicators: false) {
			LazyHStack {
				ForEach(0..<groupDetaiModel.count, id: \.self) { index in
					tagView(for: groupDetaiModel[index])
				}
			}
		}.frame(height: self.groupDetaiModel.isEmpty ? 0 : Constants.heightTagUser)
	}

	private func tagView(for model: GroupDetailUserViewModels) -> some View {
		Button {
			self.deleteSelect(model)
		} label: {
			HStack {
				Text(model.displayName)
					.font(AppTheme.shared.fontSet.font(style: .body3))
					.foregroundColor(foregroundTagUser)
					.padding([.leading, .top, .bottom], Constants.paddingTagUser)

				AppTheme.shared.imageSet.crossIcon
					.resizable()
					.aspectRatio(contentMode: .fit)
					.foregroundColor(foregroundCrossIcon)
					.padding(.trailing, Constants.paddingTagUser)
					.frame(width: Constants.sizeIcon.width, height: Constants.sizeIcon.height)
			}
			.background(backgroundTagUser)
			.cornerRadius(Constants.cornerRadiusTagUser)
			.frame(alignment: .leading)
			.frame(height: Constants.heightTagUser)
		}
	}
}

// MARK: - Private Variables
private extension TagDetailView {
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
