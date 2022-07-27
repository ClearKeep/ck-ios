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
	static let paddingTop = 17.0
	static let paddingLeading = 17.0
}

struct SearchUserView: View {
	// MARK: - Constants
	@Environment(\.colorScheme) var colorScheme
	
	// MARK: - Variables
	@Environment(\.injected) private var injected: DIContainer
	@State private var isUserChat: Bool = false
	@Binding var searchUser: [SearchUserViewModel]
	@Binding var searchText: String
	
	// MARK: - Init
	
	// MARK: - Body
	var body: some View {
		ForEach(searchUser) { item in
			VStack(alignment: .leading, spacing: Constants.spacing) {
				NavigationLink(
					destination: EmptyView(),
					isActive: $isUserChat,
					label: {
						Button(action: tapAaction) {
							HStack(spacing: Constants.spacingHstack) {
								AvatarDefault(.constant(item.displayName ?? ""), imageUrl: "")
									.frame(width: Constants.sizeImage.width, height: Constants.sizeImage.height)
								Text(makeAttributedString(text: item.displayName ?? ""))
									.font(AppTheme.shared.fontSet.font(style: .body3))
									.foregroundColor(foregroundColorUserName)
								Spacer()
							}
						}

					})
			}
			.background(backgroundColorView)
		}
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
		if let range = string.range(of: searchText) {
			string[range].foregroundColor = AppTheme.shared.colorSet.black
		}
		return string
	}

	func tapAaction() {
		self.isUserChat.toggle()
	}
}

// MARK: - Preview
#if DEBUG
struct SearchUserView_Previews: PreviewProvider {
	static var previews: some View {
		SearchUserView(searchUser: .constant([]), searchText: .constant(""))
	}
}
#endif
