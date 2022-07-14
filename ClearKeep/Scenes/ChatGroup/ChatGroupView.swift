//
//  ChatGroupView.swift
//  ClearKeep
//
//  Created by đông on 04/04/2022.
//

import SwiftUI
import Combine
import Common
import CommonUI

private enum Constants {
	static let paddingVertical = 14.0
}

struct ChatGroupView: View {
	// MARK: - Constants
	private let inspection = ViewInspector<Self>()
	
	// MARK: - Variables
	@Environment(\.injected) private var injected: DIContainer
	@Environment(\.colorScheme) private var colorScheme
	@Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
	@State private(set) var loadable: Loadable<ICreatGroupViewModels> = .notRequested
	@State private(set) var myProfile: CreatGroupProfieViewModel?
	@State private(set) var addMember: [CreatGroupGetUsersViewModel] = []
	@State private(set) var searchText: String = ""
	@State private(set) var searchData: [CreatGroupGetUsersViewModel] = []
	// MARK: - Init
	
	// MARK: - Body
	var body: some View {
		content
			.padding(.horizontal, Constants.paddingVertical)
			.onReceive(inspection.notice) { inspection.visit(self, $0) }
			.edgesIgnoringSafeArea(.all)
			.applyNavigationBarPlainStyle(title: "GroupChat.Back.Button".localized,
										  titleColor: titleColor,
										  backgroundColors: backgroundButtonBack,
										  leftBarItems: {
				BackButtonStandard(customBack)
			},
										  rightBarItems: {
				Spacer()
			})
	}
}

// MARK: - Private
private extension ChatGroupView {
	
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

// MARK: - Loading Content
private extension ChatGroupView {
	var notRequestedView: some View {
		ChatGroupContentView(loadable: $loadable, search: $searchData, getUser: .constant([]), getProfile: .constant(nil), addMember: $addMember, searchText: $searchText)
	}
	
	var loadingView: some View {
		notRequestedView.progressHUD(true)
	}
	
	func loadedView(_ data: ICreatGroupViewModels) -> AnyView {
		
		if let searchUser = data.searchUser {
			var userData = self.searchText.isEmpty ? [] : searchUser.sorted(by: { $0.displayName.lowercased().prefix(1) < $1.displayName.lowercased().prefix(1) })
			userData = searchUser.map { item in
				return CreatGroupGetUsersViewModel(id: item.id, displayName: item.displayName, workspaceDomain: DependencyResolver.shared.channelStorage.currentDomain)
			}
			DispatchQueue.main.asyncAfter(deadline: .now() + 0.05, execute: {
				self.searchData = userData
			})
		}
		
		if let searchUser = data.searchUserWithEmail {
			let userData = searchUser.sorted(by: { $0.displayName.lowercased().prefix(1) < $1.displayName.lowercased().prefix(1) })
			DispatchQueue.main.asyncAfter(deadline: .now() + 0.05, execute: {
				self.searchData = userData
			})
		}
		
		if let groupData = data.creatGroup {
			return AnyView(ChatView(messageText: "", inputStyle: .default, groupId: groupData.groupID))
		}
		
		if let profileWithLink = data.profileWithLink,
		   !addMember.contains(where: { $0.id == profileWithLink.id }) {
			DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
				addMember.append(profileWithLink)
			})
		}
		
		return AnyView(ChatGroupContentView(loadable: $loadable, search: $searchData, getUser: .constant(self.searchData), getProfile: .constant(data.getProfile), addMember: $addMember, searchText: $searchText))
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
private extension ChatGroupView {
}

// MARK: - Private Func
private extension ChatGroupView {
	func customBack() {
		self.presentationMode.wrappedValue.dismiss()
	}
}

// MARK: - Color func
private extension ChatGroupView {
	var foregroundButtonBack: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.black : AppTheme.shared.colorSet.offWhite
	}
	
	var backgroundGradientPrimary: LinearGradient {
		LinearGradient(gradient: Gradient(colors: AppTheme.shared.colorSet.gradientPrimary), startPoint: .leading, endPoint: .trailing)
	}
	
	var backgroundButtonBack: [Color] {
		colorScheme == .light ? [AppTheme.shared.colorSet.offWhite, AppTheme.shared.colorSet.offWhite] : [AppTheme.shared.colorSet.black, AppTheme.shared.colorSet.black]
	}
	
	var titleColor: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.black : AppTheme.shared.colorSet.greyLight2
	}
}

// MARK: - Interactors
private extension ChatGroupView {
}

// MARK: - Preview
#if DEBUG
struct ChatGroupView_Previews: PreviewProvider {
	static var previews: some View {
		ChatGroupView()
	}
}
#endif
