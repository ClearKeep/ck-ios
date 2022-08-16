//
//  CreateDirectMessageView.swift
//  ClearKeep
//
//  Created by MinhDev on 01/04/2022.
//

import SwiftUI
import Common
import CommonUI

struct CreateDirectMessageView: View {
	// MARK: - Constants
	private let inspection = ViewInspector<Self>()

	// MARK: - Variables
	@Environment(\.colorScheme) var colorScheme
	@Environment(\.injected) private var injected: DIContainer
	@State private(set) var loadable: Loadable<ICreatePeerViewModels> = .notRequested
	@State private(set) var searchText: String = ""
	@State private(set) var searchData: [CreatePeerUserViewModel] = []
	private let groups: [GroupViewModel]
	// MARK: - Init
	init (groups: [GroupViewModel]) {
		self.groups = groups
	}
	
	// MARK: - Body
	var body: some View {
		content
			.onReceive(inspection.notice) { inspection.visit(self, $0) }
			.edgesIgnoringSafeArea([.trailing, .leading, .top])
			.background(backgroundColorView)
			.hiddenNavigationBarStyle()
	}
}

// MARK: - Private
private extension CreateDirectMessageView {
	var content: AnyView {
		switch loadable {
		case .notRequested:
			return AnyView(notRequestedView)
		case .isLoading:
			return AnyView(loadingView)
		case .loaded(let data):
			return loadedView(data)
		case .failed(let error):
			if case CreateDirectMessageRemoteStore.CreateDirectMessageError.searchLinkError = error {
				return AnyView(errorView(title: "GroupChat.Warning".localized, message: "GroupChat.LinkIncorrect".localized))
			}
			let error = LoginViewError(error)
			return AnyView(errorView(title: error.title, message: error.message))
		}
	}
}

// MARK: - Private Variables
private extension CreateDirectMessageView {
	var backgroundColorView: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.background : AppTheme.shared.colorSet.black
	}
}

// MARK: - Loading Content
private extension CreateDirectMessageView {
	var notRequestedView: some View {
		DirectMessageContentView(loadable: $loadable, userData: $searchData, profile: .constant(nil), searchText: $searchText, groups: self.groups)
	}

	var loadingView: some View {
		notRequestedView.progressHUD(true)
	}

	func loadedView(_ data: ICreatePeerViewModels) -> AnyView {
		if let searchUser = data.searchUser {
			var userData = self.searchText.isEmpty ? [] : searchUser.sorted(by: { $0.displayName.lowercased().prefix(1) < $1.displayName.lowercased().prefix(1) })
			userData = searchUser.map { item in
				return CreatePeerUserViewModel(id: item.id, displayName: item.displayName, workspaceDomain: DependencyResolver.shared.channelStorage.currentDomain)
			}
			DispatchQueue.main.asyncAfter(deadline: .now() + 0.05, execute: {
				searchData = userData
			})
		}
		
		if let searchUser = data.searchUserWithEmail {
			let userData = searchUser.filter({ $0.id != DependencyResolver.shared.channelStorage.currentServer?.profile?.userId ?? "" }).sorted(by: { $0.displayName.lowercased().prefix(1) < $1.displayName.lowercased().prefix(1) })
			DispatchQueue.main.asyncAfter(deadline: .now() + 0.05, execute: {
				self.searchData = userData
			})
		}

		if let groupData = data.creatGroup {
			return AnyView(ChatView(messageText: "", inputStyle: .default, groupId: groupData.groupID, avatarLink: ""))
		}

		return AnyView(DirectMessageContentView(loadable: $loadable, userData: $searchData, profile: .constant(data.getProfile), searchText: $searchText, groups: self.groups))
	}

	func errorView(title: String, message: String) -> some View {
		return notRequestedView
			.alert(isPresented: .constant(true)) {
				Alert(title: Text(title),
					  message: Text(message),
					  dismissButton: .default(Text("GroupChat.OK".localized)))
			}
	}
}

// MARK: - Interactor
private extension CreateDirectMessageView {
}

// MARK: - Preview
#if DEBUG
struct CreateDirectMessageView_Previews: PreviewProvider {
	static var previews: some View {
		CreateDirectMessageView(groups: [])
	}
}
#endif
