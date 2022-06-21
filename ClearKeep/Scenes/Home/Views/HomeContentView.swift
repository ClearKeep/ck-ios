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
}

struct HomeContentView: View {
	// MARK: - Variables
	@Environment(\.colorScheme) var colorScheme
	@Binding var groups: [GroupViewModel]
	@Binding var peers: [GroupViewModel]
	@State private(set) var isSearchView: Bool = false
	@State private(set) var isCreatGroup: Bool = false
	@State private(set) var isCreatMessage: Bool = false
	@State private(set) var isNext: Bool = false
	@State private var selectedGroup: GroupViewModel?
	
	// MARK: - Body
	var body: some View {
		VStack {
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
			NavigationLink(destination: ChatView(messageText: "", inputStyle: .default, groupId: selectedGroup?.groupId ?? 0),
						   isActive: $isNext) {
				ScrollView {
					NavigationLink(destination: ChatGroupView(),
								   isActive: $isCreatGroup) {
						ListGroupView(title: "Home.GroupChat".localized, groups: groups, action: { isCreatGroup.toggle() }, onChooseGroup: { group in
							print(group)
							selectedGroup = group
							isNext.toggle()
						})
					}
					NavigationLink(destination: ChatGroupView(),
								   isActive: $isCreatGroup) {
						ListGroupView(title: "Home.DirectMessages".localized, groups: peers, action: { isCreatMessage.toggle() }, onChooseGroup: { group in
							print(group)
							selectedGroup = group
							isNext.toggle()
						})
					}
				}
			}.buttonStyle(.plain)
		}
	}
}

// MARK: - Action
private extension HomeContentView {
	func searchAction() {
	}
}
