//
//  SearchView.swift
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
	static let padding = 20.0
	static let sizeOffset = 30.0
	static let sizeIcon = 24.0
}

struct SearchView: View {
	// MARK: - Constants
	private let inspection = ViewInspector<Self>()
	@Environment(\.colorScheme) var colorScheme
	
	// MARK: - Variables
	@Environment(\.injected) private var injected: DIContainer
	@State private(set) var samples: Loadable<[ISearchModels]>
	@Binding var searchText: String
	@State private(set) var inputStyle: TextInputStyle = .default
	@Binding var isSearchAction: Bool
	@State private var searchModel: [SearchModels] = [SearchModels(id: 1, imageUser: AppTheme.shared.imageSet.userImage, userName: "Alex Mendes", message: "... this CLK is ready for tes...", groupText: "CLK - System architecture", dateMessage: "5/5/2021"),
												SearchModels(id: 2, imageUser: AppTheme.shared.imageSet.userImage, userName: "Alex Mendes", message: "... this CLK is ready for tes...", groupText: "CLK - System architecture", dateMessage: "5/5/2021"),
												SearchModels(id: 3, imageUser: AppTheme.shared.imageSet.userImage, userName: "Alex Mendes", message: "... this CLK is ready for tes...", groupText: "CLK - System architecture", dateMessage: "5/5/2021 ")]

	// MARK: - Init
	init(samples: Loadable<[ISearchModels]> = .notRequested,
		 inputStyle: TextInputStyle = .default,
		 isSearchAction: Binding<Bool>,
		 searchText: Binding<String>) {
		self._samples = .init(initialValue: samples)
		self._inputStyle = .init(initialValue: inputStyle)
		self._isSearchAction = isSearchAction
		self._searchText = searchText
	}

	// MARK: - Body
	var body: some View {
		GeometryReader { _ in
			self.content
				.onReceive(inspection.notice) { inspection.visit(self, $0) }
				.modifier(NavigationModifier())
				.edgesIgnoringSafeArea(.all)
				.background(backgroundColorView)
		}
	}
}

// MARK: - Private
private extension SearchView {
	var content: AnyView {
		searchText == "" ? AnyView(notSearchView) : AnyView(searchView)
	}
}

// MARK: - Displaying Content
private extension SearchView {
	var notSearchView: some View {
		VStack(alignment: .center) {
			Spacer()
			HStack {
				Spacer()
			Text("Search.Title.Error".localized)
				.foregroundColor(forceColorTitle)
				.frame(width: .infinity, height: .infinity, alignment: .center)
				Spacer()
			}
			Spacer()
			Spacer()
		}
	}

	var searchView: some View {
		SearchContentView(searchModel: $searchModel)
	}
}

// MARK: - Private
private extension SearchView {
	var backgroundColorView: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.background : AppTheme.shared.colorSet.black
	}

	var forceColorTitle: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.grey3 : AppTheme.shared.colorSet.greyLight
	}
}

// MARK: - Preview
#if DEBUG
struct SearchView_Previews: PreviewProvider {
	static var previews: some View {
		SearchView(isSearchAction: .constant(false), searchText: .constant(""))
	}
}
#endif
