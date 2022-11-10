//
//  ListGroupView.swift
//  ClearKeep
//
//  Created by NamNH on 12/05/2022.
//

import SwiftUI
import CommonUI
import Model

private enum Constants {
	static let arrowSize = CGSize(width: 12.0, height: 12.0)
	static let avatarSize = CGSize(width: 30.0, height: 30.0)
	static let statusSize = CGSize(width: 8.0, height: 8.0)
	static let sectionHeight = 28.0
	static let itemHeight = 24.0
	static let padding = 20.0
}

struct ListGroupView: View {
	// MARK: - Variables
	@Environment(\.colorScheme) var colorScheme
	@Binding var isExpand: Bool
	private let title: String
	private let groups: [GroupViewModel]
	private let action: () -> Void
	private let onChooseGroup: (GroupViewModel) -> Void
	
	// MARK: - Init
	init(title: String, groups: [GroupViewModel], action: @escaping () -> Void, onChooseGroup: @escaping (GroupViewModel) -> Void, isExpand: Binding<Bool>) {
		self.title = title
		self.groups = groups
		self.action = action
		self.onChooseGroup = onChooseGroup
		self._isExpand = isExpand
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
						HStack(spacing: 0) {
							let member = self.getPartnerUser(group: group)
							if group.groupType == "peer" {
								ZStack {
									MessageAvatarView(avatarSize: Constants.avatarSize,
													  statusSize: Constants.statusSize,
													  userName: group.groupMembers.count < 2 ? "Home.DeletedUser".localized : member?.userName ?? "",
													  font: AppTheme.shared.fontSet.font(style: .input3),
													  image: self.getPartnerUser(group: group)?.avatar ?? ""
									).padding(.trailing, 16)
									
									VStack {
										Spacer()
										HStack {
											Spacer()
											Circle()
												.fill(self.getPartnerUserStatusColor(group: group))
												.frame(width: Constants.statusSize.width,
													   height: Constants.statusSize.height)
												.padding(.trailing, 16)
										}.frame(maxWidth: .infinity)
									}.frame(maxWidth: .infinity, maxHeight: .infinity)
								}.frame(width: Constants.avatarSize.width,
										height: Constants.avatarSize.height,
										alignment: .bottomTrailing)
							}
							Text(group.groupType == "peer" ? (group.groupMembers.count < 2 ? "Home.DeletedUser".localized : member?.userName ?? "") : group.groupName)
								.font(group.hasUnreadMessage ? AppTheme.shared.fontSet.font(style: .body3) : AppTheme.shared.fontSet.font(style: .input3))
								.foregroundColor(colorScheme == .light ? AppTheme.shared.colorSet.grey2 : AppTheme.shared.colorSet.greyLight)
								.frame(height: Constants.itemHeight)
								.frame(maxWidth: .infinity, alignment: .leading)
						}
					}.padding([.horizontal], Constants.padding)
				}
			}
		}
		.edgesIgnoringSafeArea(.bottom)
	}
}

extension ListGroupView {
	func getPartnerUser(group: GroupViewModel) -> IMemberModel? {
		return group.groupMembers.first(where: { $0.userId != DependencyResolver.shared.channelStorage.currentServer?.profile?.userId })
	}
	
	func getPartnerUserStatusColor(group: GroupViewModel) -> Color {
		let status = getPartnerUser(group: group)?.userStatus
		return StatusType(rawValue: status ?? "")?.color ?? AppTheme.shared.colorSet.grey3
	}
}
