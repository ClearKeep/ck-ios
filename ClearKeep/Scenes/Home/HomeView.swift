//
//  HomeView.swift
//  iOSBase-SwiftUI
//
//  Created by NamNH on 15/02/2022.
//

import SwiftUI
import Combine
import Common

struct HomeView: View {
	
	@Environment(\.injected) private var injected: DIContainer
	@State private(set) var samples: Loadable<[ISampleModel]>
	let inspection = ViewInspector<Self>()
	
	init(samples: Loadable<[ISampleModel]> = .notRequested) {
		self._samples = .init(initialValue: samples)
	}
	
	var body: some View {
		GeometryReader { _ in
			NavigationView {
				self.content
					.navigationBarTitle("Home")
			}
			.navigationViewStyle(DoubleColumnNavigationViewStyle())
		}
		.onReceive(inspection.notice) { self.inspection.visit(self, $0) }
	}
}

// MARK: - Private
private extension HomeView {
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
private extension HomeView {
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
private extension HomeView {
	func loadedView(_ samples: [ISampleModel], showSearch: Bool, showLoading: Bool) -> some View {
		VStack {
			if showLoading {
				ActivityIndicatorView().padding()
			}
			ForEach(samples, id: \.id) { sample in
				Text(sample.name)
			}
			.id(samples.count)
		}.padding(.bottom, 0)
	}
}

// MARK: - Interactors
private extension HomeView {
	func reloadSamples() {
		injected.interactors.homeInteractor.worker.getSamples(samples: $samples)
	}
}

// MARK: - Preview
#if DEBUG
struct HomeView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView(container: .preview)
	}
}
#endif
