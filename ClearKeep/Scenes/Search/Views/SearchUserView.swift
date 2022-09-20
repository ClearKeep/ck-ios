//
//  SearchUserView.swift
//  ClearKeep
//
//  Created by MinhDev on 22/03/2022.
//

import SwiftUI
import Common
import CommonUI

private enum Constants {
	static let spacing = 16.0
	static let sizeImage = CGSize(width: 64.0, height: 64.0)
	static let spacingHstack = 16.0
	static let paddingTop = 16.0
	static let paddingLeading = 17.0
}

struct SearchUserView: View {
	// MARK: - Constants
	@Environment(\.colorScheme) var colorScheme

	// MARK: - Variables
	@Environment(\.injected) private var injected: DIContainer
	@State private var isUserChat: Bool = false
	@Binding var searchUser: [SearchGroupViewModel]
	@Binding var searchText: String
	@Binding var loadable: Loadable<ISearchViewModels>
	@State private(set) var clientInGroup: [SearchGroupViewModel] = []
	@State private(set) var newGroup: Int64 = 0
	@State private var isNewChat: Bool = false
	// MARK: - Init

	// MARK: - Body
	var body: some View {
		ForEach(searchUser, id: \.groupId) { item in
			if item.hasMessage {
				self.itemPeer(item: item)
			} else {
				self.itemCreatedPeer(item: item)
			}
		}
	}

	func itemPeer(item: SearchGroupViewModel) -> some View {
		return VStack(alignment: .leading, spacing: Constants.spacing) {
			NavigationLink(
				destination: ChatView(inputStyle: .default, groupId: item.groupId, avatarLink: item.groupAvatar),
				isActive: $isUserChat,
				label: {
					Button(action: tapAaction) {
						HStack(spacing: Constants.spacingHstack) {
							AvatarDefault(.constant(item.groupName ), imageUrl: item.groupAvatar )
								.frame(width: Constants.sizeImage.width, height: Constants.sizeImage.height)
							Text(makeAttributedString(text: item.groupName ))
								.font(AppTheme.shared.fontSet.font(style: .body3))
								.foregroundColor(foregroundColorUserName)
							Spacer()
						}
					}

				})
		}
		.background(backgroundColorView)
		.padding(.top, Constants.paddingTop)
	}

	func itemCreatedPeer(item: SearchGroupViewModel) -> some View {
		return VStack(alignment: .leading, spacing: Constants.spacing) {
			Button {
				createPeer(user: item)
			} label: {
				HStack(spacing: Constants.spacingHstack) {
					AvatarDefault(.constant(item.groupName ), imageUrl: item.groupAvatar )
						.frame(width: Constants.sizeImage.width, height: Constants.sizeImage.height)
					Text(makeAttributedString(text: item.groupName ))
						.font(AppTheme.shared.fontSet.font(style: .body3))
						.foregroundColor(foregroundColorUserName)
					Spacer()
				}
			}
			NavigationLink(
				destination: ChatView(inputStyle: .default, groupId: newGroup, avatarLink: ""),
				isActive: $isNewChat,
				label: { })
		}
		.background(backgroundColorView)
		.padding(.top, Constants.paddingTop)
	}
}

// MARK: - Private Variables
private extension SearchUserView {
	var backgroundColorView: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.background : AppTheme.shared.colorSet.black
	}

	var foregroundColorUserName: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.grey2 : AppTheme.shared.colorSet.greyLight
	}

	func makeAttributedString(text: String) -> AttributedString {
		var string = AttributedString(text)
		if let range = AttributedString(text.lowercased()).range(of: searchText.lowercased()) {
			string[range].foregroundColor = colorScheme == .light ? AppTheme.shared.colorSet.black : AppTheme.shared.colorSet.primaryDefault
		}
		return string
	}

	func tapAaction() {
		self.isUserChat.toggle()
	}

	func createPeer(user: SearchGroupViewModel) {
		Task {
			clientInGroup.append(user)
			let profile = DependencyResolver.shared.channelStorage.currentServer?.profile
			let client = SearchGroupViewModel(id: profile?.userId ?? "", displayName: profile?.userName ?? "", workspaceDomain: DependencyResolver.shared.channelStorage.currentDomain)
			clientInGroup.append(client)
			do {
				let data = try await injected.interactors.searchInteractor.createGroup(by: DependencyResolver.shared.channelStorage.currentServer?.profile?.userId ?? "", groupName: user.groupName, groupType: "peer", lstClient: clientInGroup).get().creatGroup?.groupID ?? 0
				print(data)
				self.newGroup = data
				self.isNewChat = true
			} catch {
				print("created error")
			}
		}
	}
}

// MARK: - Preview
#if DEBUG
struct SearchUserView_Previews: PreviewProvider {
	static var previews: some View {
		SearchUserView(searchUser: .constant([]), searchText: .constant(""), loadable: .constant(.notRequested))
	}
}
#endif
