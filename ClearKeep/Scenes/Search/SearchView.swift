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
import Model
import Networking

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
	@Environment(\.injected) private var injected: DIContainer
	@Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
	@State private(set) var loadable: Loadable<ISearchViewModels> = .notRequested
	@State private(set) var serverText: String = ""
	
	// MARK: - Init
	
	// MARK: - Body
	var body: some View {
		GeometryReader { _ in
			self.content
				.onReceive(inspection.notice) { inspection.visit(self, $0) }
				.hiddenNavigationBarStyle()
				.edgesIgnoringSafeArea(.all)
				.background(backgroundColorView)
				.onAppear(perform: getdata)
		}
	}
}

// MARK: - Private
private extension SearchView {
	var content: AnyView {
		switch loadable {
		case .notRequested:
			return AnyView(notRequestedView)
		case .isLoading:
			return AnyView(loadingView)
		case .loaded(let data):
			return loadedView(data)
		case .failed(let error):
			return AnyView(errorView(LoginViewError(error)))
		}
	}
}

// MARK: - Displaying Content
private extension SearchView {
	var notRequestedView: some View {
		SearchContentView(serverText: serverText, searchUser: .constant([]), searchGroup: .constant([]), searchMessage: .constant([]), loadable: $loadable)
	}
	
	var loadingView: some View {
		notRequestedView.progressHUD(true)
	}
	
	func loadedView(_ data: ISearchViewModels) -> AnyView {
		if let searchGroup = data.groupViewModel?.viewModelGroup {
			let lstGroup = searchGroup.filter { $0.groupType == "group" }.compactMap { profile in
				SearchGroupViewModel(group: profile)}
			
			let lstUser = searchGroup.filter { $0.groupType == "peer" }.compactMap { profile in
				SearchGroupViewModel(group: profile)}
			
			return AnyView(SearchContentView(serverText: serverText, searchCatalogy: .all, searchUser: .constant(lstUser), searchGroup: .constant(lstGroup), searchMessage: .constant([]), loadable: $loadable))
		}
		
		return AnyView(SearchContentView(serverText: serverText, searchUser: .constant([]), searchGroup: .constant([]), searchMessage: .constant([]), loadable: $loadable))
	}
	
	func errorView(_ error: LoginViewError) -> some View {
		return notRequestedView
			.alert(isPresented: .constant(true)) {
				Alert(title: Text(error.title),
					  message: Text(error.message),
					  dismissButton: .default(Text(error.primaryButtonTitle)))
			}
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
	func getdata() {
		Task {
			loadable = await injected.interactors.searchInteractor.getJoinedGroup()
		}
	}
}
// MARK: - Preview
#if DEBUG
struct SearchView_Previews: PreviewProvider {
	static var previews: some View {
		SearchView()
	}
}
#endif
