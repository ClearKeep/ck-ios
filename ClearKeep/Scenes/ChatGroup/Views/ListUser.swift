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
	static let avatarSize = CGSize(width: 64.0, height: 64.0)
}

struct ListUser: View {
	// MARK: - Variables

	@Environment(\.colorScheme) var colorScheme
	@Environment(\.injected) private var injected: DIContainer
	@Binding var user: CreatGroupGetUsersViewModel
	@Binding var imageUrl: String
	@Binding var name: String
	@State private(set) var isSelected: Bool = false

	// MARK: Init

	// MARK: - Body
	var body: some View {
		Button(action: {
			addUser()
		}, label: {
			HStack {

				avatarView
					.frame(width: Constants.avatarSize.width, height: Constants.avatarSize.height)
					.clipShape(Circle())
				Text(name)
					.frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
					.font(AppTheme.shared.fontSet.font(style: .input2))
					.foregroundColor(foregroundTagUser)
				Spacer()
				CheckBoxButtons(text: "", isChecked: $isSelected)

			}
		})
	}
}

// MARK: - Private Variables
private extension ListUser {
	var foregroundTagUser: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.grey2 : AppTheme.shared.colorSet.greyLight
	}
}

// MARK: - Private
private extension ListUser {
	var avatarView: AnyView {
		if imageUrl == "" {
			return AnyView(avatarDefault)
		} else {
			return AnyView(avatar)
		}
	}
}

// MARK: - Displaying Content
private extension ListUser {
	var avatar: some View {
		Image(imageUrl)
			.frame(width: Constants.avatarSize.width, height: Constants.avatarSize.height)
			.clipShape(Circle())
			.foregroundColor(Color.gray)
	}

	var avatarDefault: some View {
		AvatarDefault(title: String(name.prefix(1)))
	}

	func addUser() {
		isSelected.toggle()
			injected.interactors.chatGroupInteractor.addClient(user: user)
	}
}
