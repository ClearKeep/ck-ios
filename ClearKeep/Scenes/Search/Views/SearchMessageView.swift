//
//  SearchMessageView.swift
//  ClearKeep
//
//  Created by MinhDev on 22/03/2022.
//

import SwiftUI
import Common
import CommonUI

private enum Constants {
	static let spacing = 5.0
	static let spacingHstack = 16.0
	static let sizeImage = 64.0
	static let paddingTop = 28.0
	static let leading = 16.0
	static let paddingVstack = 22.0
}

struct SearchMessageView: View {
	// MARK: - Constants
	@Environment(\.colorScheme) var colorScheme
	// MARK: - Variables
	@Environment(\.injected) private var injected: DIContainer
	@State private var isMessageChat: Bool = false
	@Binding var searchText: String
	@Binding var dataMessages: [SearchMessageViewModel]

	// MARK: - Init
	
	// MARK: - Body
	var body: some View {
		ForEach(dataMessages, id: \.id) { item in
			VStack(alignment: .leading, spacing: Constants.paddingVstack) {
				NavigationLink(
					destination: EmptyView(),
					isActive: $isMessageChat,
					label: {
						HStack(spacing: Constants.spacingHstack) {
							AvatarDefault(.constant(item.fromClientName), imageUrl: item.avatar)
								.frame(width: Constants.sizeImage, height: Constants.sizeImage)
							VStack(alignment: .leading, spacing: Constants.spacing) {
								Text(item.fromClientName)
									.font(AppTheme.shared.fontSet.font(style: .body2))
									.foregroundColor(foregroundColorUserName)
								Text(makeAttributedString(text: item.message))
									.font(AppTheme.shared.fontSet.font(style: .input3))
									.foregroundColor(foregroundColorUserName)
									.frame(alignment: .center)
									.lineLimit(1)
								HStack {
									Text(getTimeAsString(timeMs: item.dateCreated, includeTime: true))
										.font(AppTheme.shared.fontSet.font(style: .input3))
										.foregroundColor(foregroundColorUserName)
									Text(item.groupName)
										.font(AppTheme.shared.fontSet.font(style: .input3))
										.foregroundColor(foregroundColorUserName)
								}
							}
							Spacer()
						}
					})
			}
			.background(backgroundColorView)
			.padding(.top, Constants.paddingTop)
		}
	}
}
// MARK: - Private Variables
private extension SearchMessageView {
	var backgroundColorView: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.background : AppTheme.shared.colorSet.black
	}
	
	var foregroundColorUserName: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.grey2 : AppTheme.shared.colorSet.greyLight
	}
	
	var foregroundColorText: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.greyLight2 : AppTheme.shared.colorSet.greyLight
	}
}

// MARK: - Private func
private extension SearchMessageView {
	func makeAttributedString(text: String) -> AttributedString {
		var string = AttributedString(text)
		if let range = AttributedString(text.lowercased()).range(of: searchText) {
			string[range].foregroundColor = AppTheme.shared.colorSet.black
		}
		return string
	}
}

// MARK: - Preview
#if DEBUG
struct SearchMessageView_Previews: PreviewProvider {
	static var previews: some View {
		SearchMessageView(searchText: .constant(""), dataMessages: .constant([]))
	}
}
#endif
