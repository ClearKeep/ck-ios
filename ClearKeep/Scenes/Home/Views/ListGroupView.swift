//
//  ListGroupView.swift
//  ClearKeep
//
//  Created by NamNH on 12/05/2022.
//

import SwiftUI
import CommonUI

private enum Constants {
	static let arrowSize = CGSize(width: 12.0, height: 12.0)
	static let sectionHeight = 28.0
	static let itemHeight = 24.0
	static let padding = 20.0
}

struct ListGroupView: View {
	// MARK: - Variables
	@Environment(\.colorScheme) var colorScheme
	@State private var isExpand: Bool = false
	private let title: String
	private let groups: [GroupViewModel]
	private let action: () -> Void
	private let onChooseGroup: (GroupViewModel) -> Void
	
	// MARK: - Init
	init(title: String, groups: [GroupViewModel], action: @escaping () -> Void, onChooseGroup: @escaping (GroupViewModel) -> Void) {
		self.title = title
		self.groups = groups
		self.action = action
		self.onChooseGroup = onChooseGroup
	}
	
	// MARK: Body
	var body: some View {
		VStack {
			HStack {
				Button(action: { isExpand.toggle() },
					   label: {
					Text(title)
						.font(AppTheme.shared.fontSet.font(style: .body2))
						.frame(height: Constants.sectionHeight, alignment: .leading)
						.foregroundColor(colorScheme == .light ? AppTheme.shared.colorSet.grey1 : AppTheme.shared.colorSet.greyLight2)
					(isExpand ? AppTheme.shared.imageSet.chevDownIcon : AppTheme.shared.imageSet.chevRightIcon)
						.frame(width: Constants.arrowSize.width, height: Constants.arrowSize.height)
						.foregroundColor(colorScheme == .light ? AppTheme.shared.colorSet.grey1 : AppTheme.shared.colorSet.greyLight2)
				})
				Spacer()
				ImageButton(AppTheme.shared.imageSet.plusIcon, action: action)
					.foregroundColor(colorScheme == .light ? AppTheme.shared.colorSet.grey1 : AppTheme.shared.colorSet.greyLight2)
			}
			
			if isExpand {
				ForEach(groups, id: \.groupId) { group in
					Button {
						onChooseGroup(group)
					} label: {
						Text(group.groupName)
							.font(group.hasUnreadMessage ? AppTheme.shared.fontSet.font(style: .body3) : AppTheme.shared.fontSet.font(style: .input3))
							.foregroundColor(colorScheme == .light ? AppTheme.shared.colorSet.grey2 : AppTheme.shared.colorSet.greyLight)
							.frame(height: Constants.itemHeight)
							.frame(maxWidth: .infinity, alignment: .leading)
					}
				}.padding([.horizontal], Constants.padding)
			}
		}
	}
}
