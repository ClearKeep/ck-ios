//
//  GroupDetailView.swift
//  ClearKeep
//
//  Created by MinhDev on 28/03/2022.
//

import SwiftUI
import Common
import CommonUI

struct GroupDetailView: View {
	// MARK: - Constants
	private let inspection = ViewInspector<Self>()

	// MARK: - Variables
	@Environment(\.injected) private var injected: DIContainer
	@Environment(\.colorScheme) private var colorScheme
	@Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
	@State private(set) var loadable: Loadable<IGroupDetailViewModels> = .notRequested
	@State private(set) var groupId: Int64 = 0
	@State private(set) var myProfile: GroupDetailUserViewModels?
	@State private(set) var addMember: [GroupDetailUserViewModels] = []
	@State private(set) var searchText: String = ""
	@State private(set) var searchData: [GroupDetailUserViewModels] = []
	// MARK: - Init

	// MARK: - Body
	var body: some View {
		content
			.onReceive(inspection.notice) { inspection.visit(self, $0) }
			.background(backgroundColorView)
			.edgesIgnoringSafeArea(.all)
			.hiddenNavigationBarStyle()
			.onAppear(perform: getGroup)
	}
}

// MARK: - Private
private extension GroupDetailView {
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

// MARK: - Private Variables
private extension GroupDetailView {
	var backgroundColorView: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.background : AppTheme.shared.colorSet.black
	}
}
// MARK: - Loading Content
private extension GroupDetailView {
	var notRequestedView: some View {
		DetailContentView(loadable: $loadable, groupData: .constant(nil), member: .constant([]))
	}

	var loadingView: some View {
		notRequestedView.progressHUD(true)
	}

	func loadedView(_ data: IGroupDetailViewModels) -> AnyView {
		if let groupData = data.getGroup {
			let members = groupData.groupMembers
			return AnyView(DetailContentView(loadable: $loadable, groupData: .constant(groupData), member: .constant(members)))
		}

		if let client = data.getClientInGroup {
			return AnyView(MemberView(loadable: $loadable, clientData: .constant(client), groupId: groupId))
		}

		if let profile = data.myProfile {
			return AnyView(AddMemberView(loadable: $loadable, search: .constant([]), groupId: groupId, myProfile: profile))
		}

		if let search = data.searchUser {
			var searchData = search.sorted(by: { $0.displayName.lowercased().prefix(1) < $1.displayName.lowercased().prefix(1) })
			searchData = search.map { item in
				return GroupDetailUserViewModels(id: item.id, displayName: item.displayName, workspaceDomain: DependencyResolver.shared.channelStorage.currentDomain)
			}
			return AnyView(AddMemberView(loadable: $loadable, search: .constant(searchData), groupId: groupId))
		}

		if let searchUser = data.searchUserWithEmail {
			let userData = searchUser.sorted(by: { $0.displayName.lowercased().prefix(1) < $1.displayName.lowercased().prefix(1) })
			return AnyView(AddMemberView(loadable: $loadable, search: .constant(userData), groupId: groupId))
		}

		if let profileWithLink = data.profileWithLink,
		   !addMember.contains(where: { $0.id == profileWithLink.id }) {
			var user = [GroupDetailUserViewModels]()
			user.append(profileWithLink)
			return AnyView(AddMemberView(loadable: $loadable, search: .constant(user), groupId: groupId, addMember: user))
		}

		return AnyView(DetailContentView(loadable: $loadable, groupData: .constant(nil), member: .constant([])))
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

// MARK: - Interactor
private extension GroupDetailView {
	func getGroup() {
		Task {
			loadable = await injected.interactors.groupDetailInteractor.getGroup(by: groupId)
		}
	}
}

// MARK: - Preview
#if DEBUG
struct GroupDetailView_Previews: PreviewProvider {
	static var previews: some View {
		GroupDetailView()
	}
}
#endif
