//
//  SearchGroupView.swift
//  ClearKeep
//
//  Created by MinhDev on 22/03/2022.
//

import SwiftUI
import Common
import CommonUI

private enum Constants {
	static let spacing = 10.0
	static let sizeImage = 64.0
	static let spacingVstack = 18.0
}

struct SearchGroupView: View {
	// MARK: - Constants
	@Environment(\.colorScheme) var colorScheme
	
	// MARK: - Variables
	@Environment(\.injected) private var injected: DIContainer
	@State private var isGroupChat: Bool = false
	@Binding var searchGroup: [SearchGroupViewModel]
	@Binding var searchText: String
	// MARK: - Init
	
	// MARK: - Body
	var body: some View {
		ForEach(searchGroup) { item in
			VStack(alignment: .leading) {
				NavigationLink(
					destination: ChatView(inputStyle: .default, groupId: item.groupId, avatarLink: ""),
					isActive: $isGroupChat,
					label: {
						Button(action: action) {
							Text(makeAttributedString(text: item.groupName))
								.font(AppTheme.shared.fontSet.font(style: .body3))
								.foregroundColor(foregroundColorText)
								.frame(maxWidth: .infinity, alignment: .leading)
						}
					})
				Spacer()
			}
			.background(backgroundColorView)
		}
	}
}

// MARK: - Private Variables
private extension SearchGroupView {
	var backgroundColorView: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.background : AppTheme.shared.colorSet.black
	}
	
	var foregroundColorUserName: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.black : AppTheme.shared.colorSet.greyLight
	}
	
	var foregroundColorText: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.grey2 : AppTheme.shared.colorSet.greyLight
	}
}

// MARK: - Private func
private extension SearchGroupView {
	func makeAttributedString(text: String) -> AttributedString {
		var string = AttributedString(text)
		if let range = AttributedString(text.lowercased()).range(of: searchText) {
			string[range].foregroundColor = AppTheme.shared.colorSet.black
		}
		return string
	}

	func action() {
		self.isGroupChat.toggle()
	}
}

// MARK: - Preview
#if DEBUG

struct SearchGroupView_Previews: PreviewProvider {
	static var previews: some View {
		SearchGroupView(searchGroup: .constant([]), searchText: .constant(""))
	}
}
#endif
