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
	@State private(set) var searchText: String = ""
	@State private(set) var inputStyle: TextInputStyle = .default
	@Binding var isSearchAction: Bool

	// MARK: - Init
	init(samples: Loadable<[ISearchModels]> = .notRequested,
		 inputStyle: TextInputStyle = .default,
		 isSearchAction: Binding<Bool>) {
		self._samples = .init(initialValue: samples)
		self._inputStyle = .init(initialValue: inputStyle)
		self._isSearchAction = isSearchAction
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
		switch samples {
		case .notRequested: return AnyView(notRequestedView)
		case let .isLoading(last, _): return AnyView(loadingView(last))
		case let .loaded(countries): return AnyView(loadedView(countries, showSearch: true, showLoading: false))
		case let .failed(error): return AnyView(failedView(error))
		}
	}
}

// MARK: - Loading Content
private extension SearchView {
	var notRequestedView: some View {
		VStack(alignment: .center) {
			Spacer()
			HStack {
				Spacer()
			Text("Search.Title.Error".localized)
				.foregroundColor(forceColorTitle)
				.onAppear(perform: reloadSamples)
				.frame(width: .infinity, height: .infinity, alignment: .center)
				Spacer()
			}
			Spacer()
			Spacer()
		}
	}

	func loadingView(_ previouslyLoaded: [ISearchModels]?) -> some View {
		if let samples = previouslyLoaded {
			return AnyView(loadedView(samples, showSearch: true, showLoading: true))
		} else {
			return AnyView(ActivityIndicatorView().padding())
		}
	}

	func failedView(_ error: Error) -> some View {
		ErrorView(error: error, retryAction: {
			self.reloadSamples()
		})
	}
}

// MARK: - Displaying Content
private extension SearchView {
	func loadedView(_ samples: [ISearchModels], showSearch: Bool, showLoading: Bool) -> some View {
		VStack {
			if showLoading {
				ActivityIndicatorView().padding()
			}
			SearchContentView()
		}.padding(.bottom, 0)
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

// MARK: - Interactors
private extension SearchView {
	func reloadSamples() {
	}
}
// MARK: - Preview
#if DEBUG
struct SearchView_Previews: PreviewProvider {
	static var previews: some View {
		SearchView(isSearchAction: .constant(false))
	}
}
#endif
