//
//  SearchAllView.swift
//  ClearKeep
//
//  Created by MinhDev on 05/04/2022.
//

import SwiftUI
import Combine
import Common
import CommonUI

private enum Constants {
	static let paddingTop = 16.0
	static let spacing = 10.0
}

struct SearchAllView: View {
	// MARK: - Constants
	@Environment(\.colorScheme) var colorScheme
	
	// MARK: - Variables
	@Environment(\.injected) private var injected: DIContainer
	@Binding var searchUser: [SearchGroupViewModel]
	@Binding var searchGroup: [SearchGroupViewModel]
	@Binding var searchText: String
	@Binding var dataMessages: [SearchMessageViewModel]
	@Binding var loadable: Loadable<ISearchViewModels>
	
	// MARK: - Init
	
	// MARK: - Body
	var body: some View {
		content
			.background(backgroundColorView)
	}
}

// MARK: - Private variable
private extension SearchAllView {
	
	var backgroundColorView: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.background : AppTheme.shared.colorSet.black
	}
	
	var foregroundColorTitle: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.grey1 : AppTheme.shared.colorSet.greyLight
	}
	
	var backgroundButtonDark: LinearGradient {
		LinearGradient(gradient: Gradient(colors: AppTheme.shared.colorSet.gradientPrimary), startPoint: .leading, endPoint: .trailing)
	}
	
	var backgroundButtonLight: LinearGradient {
		LinearGradient(gradient: Gradient(colors: [AppTheme.shared.colorSet.offWhite, AppTheme.shared.colorSet.offWhite]), startPoint: .leading, endPoint: .trailing)
	}
	
	var forceColorTitle: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.grey3 : AppTheme.shared.colorSet.greyLight
	}
}

// MARK: - Private view
private extension SearchAllView {
	
	var content: AnyView {
		AnyView(resultView)
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
	
	var resultView: some View {
		ScrollView(showsIndicators: false) {
			VStack(alignment: .leading, spacing: Constants.spacing) {
				Text("Search.People".localized.uppercased())
					.font(AppTheme.shared.fontSet.font(style: .body2))
					.foregroundColor(foregroundColorTitle)
				SearchUserView(searchUser: $searchUser, searchText: $searchText, loadable: $loadable)
				Text("Search.GroupChat".localized.uppercased())
					.font(AppTheme.shared.fontSet.font(style: .body2))
					.foregroundColor(foregroundColorTitle)
				SearchGroupView(searchGroup: $searchGroup, searchText: $searchText)
				Text("Search.Message".localized.uppercased())
					.font(AppTheme.shared.fontSet.font(style: .body2))
					.foregroundColor(foregroundColorTitle)
				SearchMessageView(searchText: $searchText, dataMessages: $dataMessages)
				Spacer()
			}
			.padding(.top, Constants.paddingTop)
		}
	}
}
