//
//  SearchContentView.swift
//  ClearKeep
//
//  Created by MinhDev on 22/03/2022.
//

import SwiftUI
import Combine
import Common
import CommonUI

private enum Constants {
	static let spacing = 20.0
	static let padding = 20.0
	static let spacingContent = 20.0
	static let radius = 8.0
	static let heightCatalog = 28.0
}

struct SearchContentView: View {
	// MARK: - Constants
	@Environment(\.colorScheme) var colorScheme
	// MARK: - Variables
	@Environment(\.injected) private var injected: DIContainer
	@Binding var imageUser: Image
	@Binding var userName: String
	@Binding var message: String
	@Binding var groupText: String
	@Binding var dateMessage: String
	var categories = ["All", "People", "Group", "Message"]
	@State private var selectedTab: Int = 0

	// MARK: - Init
	init(imageUser: Binding<Image>,
		 userName: Binding<String>,
		 message: Binding<String>,
		 groupText: Binding<String>,
		 dateMessage: Binding<String>) {
		self._imageUser = imageUser
		self._userName = userName
		self._message = message
		self._groupText = groupText
		self._dateMessage = dateMessage
	}
	
	// MARK: - Body
	var body: some View {
		content
			.background(backgroundColorView)
	}
}

// MARK: - Private
private extension SearchContentView {
	var content: AnyView {
		AnyView(contentView)
	}

	var searchCatalogContent: AnyView {
		AnyView(searchCatalogView)
	}

	var allContent: AnyView {
		AnyView(allView)
	}

	var peopleContent: AnyView {
		AnyView((peopleView))
	}

	var groupContent: AnyView {
		AnyView(groupView)
	}

	var messageContent: AnyView {
		AnyView(messageView)
	}
}

// MARK: - Private variable
private extension SearchContentView {
	var backgroundColorView: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.background : AppTheme.shared.colorSet.black
	}
	
	var foregroundColorButton: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.primaryDefault : AppTheme.shared.colorSet.offWhite
	}

	var foregroundColorTitle: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.grey1 : AppTheme.shared.colorSet.greyLight
	}

	var backgroundButton: LinearGradient {
		colorScheme == .light ? backgroundButtonLight : backgroundButtonDark
	}

	var backgroundButtonDark: LinearGradient {
		LinearGradient(gradient: Gradient(colors: AppTheme.shared.colorSet.gradientPrimary), startPoint: .leading, endPoint: .trailing)
	}

	var backgroundButtonLight: LinearGradient {
		LinearGradient(gradient: Gradient(colors: [AppTheme.shared.colorSet.offWhite, AppTheme.shared.colorSet.offWhite]), startPoint: .leading, endPoint: .trailing)
	}
}

// MARK: - Private
private extension SearchContentView {
}

// MARK: - Loading Content
private extension SearchContentView {
	var contentView: some View {
		VStack(spacing: Constants.spacingContent) {
			searchCatalogContent
			tabView
			Spacer()
		}
	}

	var tabView: some View {
		TabView(selection: $selectedTab,
				content: {
			allContent
				.tag(0)
			peopleContent
				.tag(1)
			groupContent
				.tag(2)
			messageContent
				.tag(3)
		})
			.tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
	}

	var searchCatalogView: some View {
		ScrollView(.horizontal, showsIndicators: false) {
			HStack(spacing: Constants.spacing) {
				ForEach(0..<categories.count, id: \.self) { data in
					Button {
						withAnimation {
							selectedTab = data
						}
					} label: {
						Text(categories[data])
							.font(AppTheme.shared.fontSet.font(style: .body3))
							.foregroundColor(foregroundColorButton)
							.padding(.horizontal)
							.animation(.spring())
							.frame(height: Constants.heightCatalog)
							.background(backgroundButton)
							.cornerRadius(Constants.radius)
					}
				}
			}
		}
	}

	var allView: some View {
		SearchAllView(imageUser: $imageUser, userName: $userName, message: $message, groupText: $groupText, dateMessage: $dateMessage)
			.background(backgroundColorView)
	}

	var peopleView: some View {
		ScrollView(showsIndicators: false) {
			SearchUserView(imageUser: $imageUser, userName: $userName)
		}
		.background(backgroundColorView)
	}

	var groupView: some View {
		ScrollView(showsIndicators: false) {
			SearchGroupView(groupText: $groupText)
		}
		.background(backgroundColorView)
	}

	var messageView: some View {
		ScrollView(showsIndicators: false) {
			SearchMessageView(imageUser: $imageUser, userName: $userName, message: $message, groupText: $groupText, dateMessage: $dateMessage)
		}
		.background(backgroundColorView)
	}
}

// MARK: - Interactor
private extension SearchContentView {
}

// MARK: - Preview
#if DEBUG
struct SearchContentView_Previews: PreviewProvider {
	static var previews: some View {
		SearchContentView(imageUser: .constant(Image("")), userName: .constant(""), message: .constant(""), groupText: .constant(""), dateMessage: .constant(""))
	}
}
#endif
