//
//  HomeContentView.swift
//  ClearKeep
//
//  Created by NamNH on 17/05/2022.
//

import SwiftUI

private enum Constants {
	static let cornerRadius = 16.0
	static let hSpacing = 28.0
	static let searchHeight = 52.0
	static let spacing = 24.0
}

struct HomeContentView: View {
	// MARK: - Variables
	@Environment(\.colorScheme) var colorScheme
	@Binding var groups: [GroupViewModel]
	@Binding var peers: [GroupViewModel]
	@State private(set) var isSearchView: Bool = false
	@State private(set) var isCreateGroup: Bool = false
	@State private(set) var isCreateMessage: Bool = false
	@State private(set) var isNext: Bool = false
	@State private var selectedGroup: GroupViewModel?
	@Binding var serverName: String
	@Binding var isExpandGroup: Bool
	@Binding var isExpandDirectMessage: Bool

	// MARK: - Body
	var body: some View {
		VStack(spacing: Constants.spacing) {
			Button(action: searchAction, label: {
				HStack(spacing: Constants.hSpacing) {
					AppTheme.shared.imageSet.searchIcon
						.foregroundColor(AppTheme.shared.colorSet.greyLight)
					Text("Home.Search".localized)
						.font(AppTheme.shared.fontSet.font(style: .input3))
						.foregroundColor(AppTheme.shared.colorSet.greyLight)
				}
				.padding()
				.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
			})
			.frame(height: Constants.searchHeight)
			.background(colorScheme == .light ? AppTheme.shared.colorSet.grey5 : AppTheme.shared.colorSet.darkgrey3)
			.cornerRadius(Constants.cornerRadius)
			ScrollView {
				ListGroupView(title: "Home.GroupChat".localized + " (\(groups.count)) ",
							  groups: groups,
							  action: { isCreateGroup.toggle() }, onChooseGroup: { group in
					selectedGroup = group
					isNext.toggle()
				},
							  isExpand: $isExpandGroup)
				
				ListGroupView(title: "Home.DirectMessages".localized + " (\(peers.count)) ",
							  groups: peers,
							  action: { isCreateMessage.toggle() },
							  onChooseGroup: { group in
					selectedGroup = group
					isNext.toggle()
				}, isExpand:
								$isExpandDirectMessage)
			}
		}
		NavigationLink(destination: ChatView(messageText: "", inputStyle: .default, groupId: selectedGroup?.groupId ?? 0),
					   isActive: $isNext) {
			
		}.buttonStyle(.plain)
		
		NavigationLink(destination: CreateDirectMessageView(groups: peers),
					   isActive: $isCreateMessage) {}
		
		NavigationLink(destination: ChatGroupView(),
					   isActive: $isCreateGroup) {}

		NavigationLink(destination: SearchView(serverText: serverName),
					   isActive: $isSearchView) {}
	}
}

// MARK: - Action
private extension HomeContentView {
	func searchAction() {
		self.isSearchView.toggle()
	}
}
