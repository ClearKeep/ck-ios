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
	@Binding var imageUrl: String
	@Binding var name: String
	
	// MARK: - Body
	var body: some View {
		HStack {
			AvatarDefault(.constant(name), imageUrl: imageUrl)
				.frame(width: Constants.avatarSize.width, height: Constants.avatarSize.height)
				.clipShape(Circle())
			Text(name)
				.frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
				.font(AppTheme.shared.fontSet.font(style: .input2))
				.foregroundColor(foregroundTagUser)
		}
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

}

// MARK: - Displaying Content
private extension ListUser {
	var avatar: some View {
		Image(imageUrl)
			.frame(width: Constants.avatarSize.width, height: Constants.avatarSize.height)
			.clipShape(Circle())
			.foregroundColor(Color.gray)
	}
}
