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
	static let paddingLeading = 100.0
	static let spacing = 10.0
	static let padding = 20.0
	static let spacingContent = 20.0
	static let paddingCatalog = 5.0
	static let radius = 8.0
	static let heightCatalog = 28.0
}

struct SearchContentView: View {
	// MARK: - Constants
	@Environment(\.colorScheme) var colorScheme
	// MARK: - Variables
	@Environment(\.injected) private var injected: DIContainer
	@State private(set) var searchCatalogy: SearchCatalogy = .all
	@Binding var imageUser: Image
	@Binding var userName: String
	@Binding var message: String
	@Binding var groupText: String
	@Binding var dateMessage: String

	// MARK: - Init
	init(searchCatalogy: SearchCatalogy = .all,
		 imageUser: Binding<Image>,
		 userName: Binding<String>,
		 message: Binding<String>,
		 groupText: Binding<String>,
		 dateMessage: Binding<String>) {
		self._searchCatalogy = .init(initialValue: searchCatalogy)
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
			.edgesIgnoringSafeArea(.all)
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
	func allAction() {
		self.searchCatalogy = .all

	}

	func peopleAction() {
		self.searchCatalogy = .people

	}

	func groupAction() {
		self.searchCatalogy = .group

	}

	func messageAction() {
		self.searchCatalogy = .message

	}
}

// MARK: - Loading Content
private extension SearchContentView {
	var contentView: some View {
		VStack(alignment: .leading, spacing: Constants.spacingContent) {
			searchCatalogContent
			HStack {
				Group {
					switch searchCatalogy {
					case .all:
						allContent
					case .people:
						peopleContent
					case .group:
						groupContent
					case .message:
						messageContent
					}
				}
			}
			Spacer()
		}
	}

	var searchCatalogView: some View {
		HStack(alignment: .center) {
			Button(action: allAction) {
				Text("Search.All".localized)
					.font(AppTheme.shared.fontSet.font(style: .body3))
					.foregroundColor(foregroundColorButton)
					.padding(.horizontal)
			}
			.frame(height: Constants.heightCatalog)
			.background(backgroundButton)
			.cornerRadius(Constants.radius)
			Button(action: peopleAction) {
				Text("Search.People".localized)
					.font(AppTheme.shared.fontSet.font(style: .body3))
					.foregroundColor(foregroundColorButton)
					.padding(.horizontal)
			}
			.frame(height: Constants.heightCatalog)
			.background(backgroundButton)
			.cornerRadius(Constants.radius)
			Button(action: groupAction) {
				Text("Search.Group".localized)
					.font(AppTheme.shared.fontSet.font(style: .body3))
					.foregroundColor(foregroundColorButton)
					.padding(.horizontal)
			}
			.frame(height: Constants.heightCatalog)
			.background(backgroundButton)
			.cornerRadius(Constants.radius)
			Button(action: messageAction) {
				Text("Search.Message".localized)
					.font(AppTheme.shared.fontSet.font(style: .body3))
					.foregroundColor(foregroundColorButton)
					.padding(.horizontal)
			}
			.frame(height: Constants.heightCatalog)
			.background(backgroundButton)
			.cornerRadius(Constants.radius)
			Spacer()
		}
		.frame(height: Constants.heightCatalog)
	}

	var allView: some View {
		ScrollView {
			VStack(alignment: .leading, spacing: Constants.spacing) {
				Text("Search.People".localized.uppercased())
					.padding(.all)
					.font(AppTheme.shared.fontSet.font(style: .body2))
					.foregroundColor(foregroundColorTitle)
				SearchUserView(imageUser: $imageUser, userName: $userName)
				Text("Search.GroupChat".localized.uppercased())
					.padding(.all)
					.font(AppTheme.shared.fontSet.font(style: .body2))
					.foregroundColor(foregroundColorTitle)
				SearchGroupView(groupText: $groupText)
				Text("Search.Message".localized.uppercased())
					.padding(.all)
					.font(AppTheme.shared.fontSet.font(style: .body2))
					.foregroundColor(foregroundColorTitle)
				SearchMessageView(imageUser: $imageUser, userName: $userName, message: $message, groupText: $groupText, dateMessage: $dateMessage)
				Spacer()
			}
		}
	}

	var peopleView: some View {
		ScrollView {
			SearchUserView(imageUser: $imageUser, userName: $userName)
		}
	}

	var groupView: some View {
		ScrollView {
			SearchGroupView(groupText: $groupText)
		}
	}

	var messageView: some View {
		ScrollView {
			SearchMessageView(imageUser: $imageUser, userName: $userName, message: $message, groupText: $groupText, dateMessage: $dateMessage)
		}
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
