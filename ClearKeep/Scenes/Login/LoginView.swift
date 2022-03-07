//
//  LoginView.swift
//  ClearKeep
//
//  Created by đông on 07/03/2022.
//

import SwiftUI
import Combine
import Common
import CommonUI

struct LoginView: View {

	@Environment(\.injected) private var injected: DIContainer
	@State private(set) var samples: Loadable<[ISampleModel]>
	@State private(set) var searchKeyword: String = ""
	@State private(set) var searchInputStyle: TextInputStyle = .default
	let inspection = ViewInspector<Self>()

	init(samples: Loadable<[ISampleModel]> = .notRequested,
		 searchKeyword: String = "",
		 searchInputStyle: TextInputStyle = .default) {
		self._samples = .init(initialValue: samples)
		self._searchKeyword = .init(initialValue: searchKeyword)
		self._searchInputStyle = .init(initialValue: searchInputStyle)
	}

	var body: some View {
		GeometryReader { _ in
			NavigationView {
				self.content
					.navigationBarTitle("Login")
			}
			.navigationViewStyle(DoubleColumnNavigationViewStyle())
		}
		.onReceive(inspection.notice) { self.inspection.visit(self, $0) }
	}
}

// MARK: - Private
private extension LoginView {
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
private extension LoginView {
	var notRequestedView: some View {
		Text("").onAppear(perform: reloadSamples)
	}

	func loadingView(_ previouslyLoaded: [ISampleModel]?) -> some View {
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
private extension LoginView {
	func loadedView(_ samples: [ISampleModel], showSearch: Bool, showLoading: Bool) -> some View {
		VStack {
			if showLoading {
				ActivityIndicatorView().padding()
			}
			ForEach(samples, id: \.id) { sample in
				Text(sample.name)
			}
			.id(samples.count)
			HomeHeaderView(searchText: $searchKeyword, inputStyle: $searchInputStyle)
		}.padding(.bottom, 0)
	}
}

// MARK: - Interactors
private extension LoginView {
	func reloadSamples() {
		injected.interactors.homeInteractor.worker.getSamples(samples: $samples)
	}
}

// MARK: - Preview
#if DEBUG
struct LoginView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView(container: .preview)
	}
}
#endif
