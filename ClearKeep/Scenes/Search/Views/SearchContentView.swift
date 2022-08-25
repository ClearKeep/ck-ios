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
import RealmSwift
import ChatSecure
import Model

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
	@State private(set) var searchUserData: [SearchGroupViewModel] = []
	@State private(set) var searchGroupData: [SearchGroupViewModel] = []
	@State private(set) var serverText: String = ""
	@Binding var searchCatalogy: SearchCatalogy
	@State private var searchKeywordStyle: TextInputStyle = .default
	@State private(set) var searchUser: [SearchGroupViewModel] = []
	@State private(set) var searchGroup: [SearchGroupViewModel] = []
	@Binding var loadable: Loadable<ISearchViewModels>
	@State private(set) var dataMessages: [SearchMessageViewModel] = []
	@State private(set) var searchdataMessages: [SearchMessageViewModel] = []
	
	// MARK: - Init
	
	// MARK: - Body
	var body: some View {
		content
	}
}

// MARK: - Private
private extension SearchContentView {
	
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
	
	var content: AnyView {
		searchUser.isEmpty && searchGroup.isEmpty && dataMessages.isEmpty ? AnyView(notRequestView) : AnyView(contentView)
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
	
	var forehigroundColorTitle: Color {
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
		Group {
			switch searchCatalogy {
			case .all:
				AnyView(allView)
			case .people:
				AnyView(peopleContent)
			case .group:
				AnyView(groupContent)
			case .message:
				AnyView(messageContent)
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
		SearchAllView(searchUser: .constant(searchUser), searchGroup: .constant(searchGroup), searchText: $searchText, dataMessages: .constant(dataMessages), loadable: $loadable )
	}
	
	var peopleView: some View {
		ScrollView(showsIndicators: false) {
			SearchUserView(searchUser: .constant(searchUser), searchText: $searchText, loadable: $loadable)
		}
	}
	
	var groupView: some View {
		ScrollView(showsIndicators: false) {
			SearchGroupView( searchGroup: .constant(searchGroup), searchText: $searchText)
		}
	}
	
	var messageView: some View {
		ScrollView(showsIndicators: false) {
			SearchMessageView(searchText: $searchText, dataMessages: .constant(dataMessages))
		}
	}
	
}

// MARK: - Interactor
private extension SearchContentView {
	func back() {
		self.presentationMode.wrappedValue.dismiss()
	}
}
// MARK: - Preview
#if DEBUG
struct SearchContentView_Previews: PreviewProvider {
	static var previews: some View {
		SearchContentView(searchCatalogy: .constant(.all), loadable: .constant(.notRequested))
	}
}
#endif
