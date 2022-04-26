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
}

struct SearchContentView: View {
	// MARK: - Constants
	@Environment(\.colorScheme) var colorScheme
	
	// MARK: - Variables
	@Environment(\.injected) private var injected: DIContainer
	@State private(set) var searchCatalogy: SearchCatalogy = .all
	@State private var selectedTab: Int = 0
	@State private var isSelected: Bool = false
	@State private var model: [SearchModels] = []
	
	// MARK: - Init
	init(searchCatalogy: SearchCatalogy = .all) {
		self._searchCatalogy = .init(initialValue: searchCatalogy)
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

// MARK: - Loading Content
private extension SearchContentView {
	var contentView: some View {
		VStack {
			searchCatalogContent
			catalogView
			Spacer()
		}
	}
	
	var catalogView: some View {
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
	
	var searchCatalogView: some View {
		CatalogyView(states: SearchCatalogy.allCases, selectedState: $searchCatalogy)
	}
	
	var allView: some View {
		SearchAllView()
	}
	
	var peopleView: some View {
		ScrollView(showsIndicators: false) {
			SearchUserView()
		}
	}
	
	var groupView: some View {
		ScrollView(showsIndicators: false) {
			SearchGroupView()
		}
	}
	
	var messageView: some View {
		ScrollView(showsIndicators: false) {
			SearchMessageView()
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
		SearchContentView()
	}
}
#endif
