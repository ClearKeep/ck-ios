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
import RealmSwift
import ChatSecure

private enum Constants {
	static let paddingLeading = 100.0
	static let padding = 20.0
	static let sizeOffset = 30.0
	static let sizeIcon = 24.0
	static let spacingSearch = 16.0
}

struct SearchView: View {
	// MARK: - Constants
	private let inspection = ViewInspector<Self>()
	@Environment(\.colorScheme) var colorScheme
	@Environment(\.injected) private var injected: DIContainer
	@Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
	@State private(set) var loadable: Loadable<ISearchViewModels> = .notRequested
	@State private(set) var serverText: String = ""
	@State private(set) var inputStyle: TextInputStyle = .default
	@State private(set) var searchText: String = ""
	@State private(set) var searchCatalogy: SearchCatalogy = .all
	@State private var searchKeywordStyle: TextInputStyle = .default
	// MARK: - Body
	var body: some View {
		GeometryReader { _ in
			VStack {
				SearchTextField(searchText: $searchText,
								inputStyle: $searchKeywordStyle,
								placeHolder: "Search.Placehodel".localized,
								onEditingChanged: { isEditing in
					searchKeywordStyle = isEditing ? .highlighted : .normal
				},
								onSubmit: { seachAction(text: searchText) })
					.onReceive(searchText.publisher.collect()) {
						self.searchText = String($0.prefix(200))
					}
				CatalogyView(states: SearchCatalogy.allCases, selectedState: $searchCatalogy, selected: SearchCatalogy.all.title)
				content
				Spacer()
			}
			.padding(.horizontal, Constants.spacingSearch)
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
			.onReceive(inspection.notice) { inspection.visit(self, $0) }
			.hiddenNavigationBarStyle()
			.edgesIgnoringSafeArea(.all)
			.background(backgroundColorView)
			.onAppear(perform: { seachAction(text: searchText) })
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
		VStack(alignment: .center) {
			Spacer()
			HStack {
				Spacer()
				Text("Search.Title.Error".localized)
					.foregroundColor(forceColorTitle)
				Spacer()
			}
			Spacer()
		}
	}
	
	var loadingView: some View {
		notRequestedView.progressHUD(true)
	}
	
	func loadedView(_ data: ISearchViewModels) -> AnyView {
		if let searchGroup = data.groupViewModel?.viewModelGroup {
			let lstGroup = searchGroup.filter { $0.groupType == "group" }.filter { $0.groupName.lowercased().contains(searchText) }.sorted { $0.updatedAt > $1.updatedAt }

			let lstUser = searchGroup.filter { $0.groupType != "group" }.filter { $0.groupName.lowercased().contains(searchText) }

			var dataMessages = [SearchMessageViewModel]()
			searchGroup.forEach { group in
				let messages = injected.interactors.searchInteractor.getMessageFromLocal(groupId: group.groupId)
				messages?.forEach { message in
					dataMessages.append(SearchMessageViewModel(data: message, members: group.groupMembers, group: group.groupName))
				}
			}
			
			let searchDataMessage = dataMessages.filter { $0.message.lowercased().contains(searchText) }.sorted { $0.dateCreated > $1.dateCreated }
			return AnyView(SearchContentView(searchText: searchText, serverText: serverText, searchCatalogy: $searchCatalogy, searchUser: lstUser, searchGroup: lstGroup, loadable: $loadable, dataMessages: searchDataMessage))
		}

		return AnyView(notRequestedView)
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

	var titleColor: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.black : AppTheme.shared.colorSet.greyLight2
	}

	var backgroundButtonBack: [Color] {
		colorScheme == .light ? [AppTheme.shared.colorSet.background, AppTheme.shared.colorSet.background] : [AppTheme.shared.colorSet.black, AppTheme.shared.colorSet.black]
	}
}

// MARK: - Interactors
private extension SearchView {
	func seachAction(text: String) {
		loadable = .isLoading(last: nil, cancelBag: CancelBag())
		Task {
			loadable = await injected.interactors.searchInteractor.searchUser(keyword: text)
		}
	}

	func back() {
		self.presentationMode.wrappedValue.dismiss()
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
