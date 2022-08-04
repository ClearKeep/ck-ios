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
	static let spacingSearch = 16.0
}

struct SearchContentView: View {
	// MARK: - Constants
	@Environment(\.colorScheme) var colorScheme
	
	// MARK: - Variables
	@Environment(\.injected) private var injected: DIContainer
	@Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
	@State private(set) var inputStyle: TextInputStyle = .default
	@State private(set) var searchText: String = ""
	@State private(set) var searchModels: [SearchGroupViewModel] = []
	@State private(set) var serverText: String = ""
	@State private(set) var searchCatalogy: SearchCatalogy = .all
	@State private var searchKeywordStyle: TextInputStyle = .default
	@Binding var searchUser: [SearchUserViewModel]
	@Binding var searchGroup: [SearchGroupViewModel]
	@Binding var searchMessage: [SearchGroupViewModel]
	@Binding var loadable: Loadable<ISearchViewModels>

	// MARK: - Init
	
	// MARK: - Body
	var body: some View {
		content
			.background(backgroundColorView)
			.applyNavigationBarPlainStyle(title: "",
										  titleColor: titleColor,
										  backgroundColors: backgroundButtonBack,
										  leftBarItems: {
				Text(serverText)
					.font(AppTheme.shared.fontSet.font(style: .display3))
					.foregroundColor(titleColor)
			},
										  rightBarItems: {
				ImageButton(AppTheme.shared.imageSet.crossIcon, action: back)
					.foregroundColor(titleColor)
			})
	}
}

// MARK: - Private
private extension SearchContentView {
	var content: AnyView {
		AnyView(contentView)
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

	var resultView: AnyView {
		searchUser.isEmpty ? AnyView(notRequestView) : AnyView(catalogView)
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

	var backgroundButtonBack: [Color] {
		colorScheme == .light ? [AppTheme.shared.colorSet.background, AppTheme.shared.colorSet.background] : [AppTheme.shared.colorSet.black, AppTheme.shared.colorSet.black]
	}

	var titleColor: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.black : AppTheme.shared.colorSet.greyLight2
	}

	var forceColorTitle: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.grey3 : AppTheme.shared.colorSet.greyLight
	}
}

// MARK: - Loading Content
private extension SearchContentView {
	var contentView: some View {
		VStack {
			SearchTextField(searchText: $searchText,
							inputStyle: $searchKeywordStyle,
							placeHolder: "Search.Placehodel".localized,
							onEditingChanged: { isEditing in
				searchKeywordStyle = isEditing ? .highlighted : .normal
			})
				.onChange(of: searchText, perform: { writing in
					seachAction(text: writing)
				})
				.onReceive(searchText.publisher.collect()) {
					self.searchText = String($0.prefix(20))
				}
			CatalogyView(states: SearchCatalogy.allCases, selectedState: $searchCatalogy)
			resultView
			Spacer()
		}
		.padding(.horizontal, Constants.spacingSearch)
	}
	
	var catalogView: some View {
		Group {
			switch searchCatalogy {
			case .all:
				searchUser.isEmpty && searchGroup.isEmpty ? AnyView(notRequestView) : AnyView(allView)
			case .people:
				searchUser.isEmpty ? AnyView(notRequestView) : AnyView(peopleContent)
			case .group:
				searchGroup.isEmpty ? AnyView(notRequestView) : AnyView(groupContent)
			case .message:
				searchUser.isEmpty ? AnyView(notRequestView) : AnyView(messageContent)
			}
		}
	}
	var notRequestView: some View {
		VStack(alignment: .center) {
			Spacer()
			HStack {
				Spacer()
				Text("Search.Title.Error".localized)
					.foregroundColor(forceColorTitle)
				Spacer()
			}
			Spacer()
			Spacer()
		}
	}
	
	var allView: some View {
		SearchAllView(searchUser: .constant(searchUser), searchGroup: .constant(searchGroup), searchMessage: .constant(searchMessage), searchText: $searchText)
	}
	
	var peopleView: some View {
		ScrollView(showsIndicators: false) {
			SearchUserView(searchUser: .constant(searchUser), searchText: $searchText)
		}
	}
	
	var groupView: some View {
		ScrollView(showsIndicators: false) {
			SearchGroupView( searchGroup: .constant(searchGroup), searchText: $searchText)
		}
	}
	
	var messageView: some View {
		ScrollView(showsIndicators: false) {
			SearchMessageView(searchMessage: .constant(searchMessage), searchText: $searchText)
		}
	}

}

// MARK: - Interactor
private extension SearchContentView {
	func seachAction(text: String) {
		if text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
			loadable = .loaded(SearchViewModels(searchGroup: [], searchUser: []))
			return
		}
		Task {
			loadable = await injected.interactors.searchInteractor.searchAll(text)
		}
	}

	func back() {
		self.presentationMode.wrappedValue.dismiss()
	}
}

// MARK: - Preview
#if DEBUG
struct SearchContentView_Previews: PreviewProvider {
	static var previews: some View {
		SearchContentView(searchUser: .constant([]), searchGroup: .constant([]), searchMessage: .constant([]), loadable: .constant(.notRequested))
	}
}
#endif
