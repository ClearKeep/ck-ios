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
	
	// MARK: - Init
	
	// MARK: - Body
	var body: some View {
		content
			.onReceive(inspection.notice) { inspection.visit(self, $0) }
			.edgesIgnoringSafeArea(.all)
			.hiddenNavigationBarStyle()
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
		ChatGroupContentView(loadable: $loadable, search: .constant([]), getUser: .constant([]), getProfile: .constant(nil))
	}
	
	var loadingView: some View {
		notRequestedView.progressHUD(true)
	}
	
	func loadedView(_ data: ICreatGroupViewModels) -> AnyView {
		
		if let searchUser = data.searchUser {
			let userData = searchUser.sorted(by: { $0.displayName.lowercased().prefix(1) < $1.displayName.lowercased().prefix(1) })
			return AnyView(ChatGroupContentView(loadable: $loadable, search: .constant(userData), getUser: .constant([]), getProfile: .constant(data.getProfile)))
		}
		
		if let groupData = data.creatGroup {
			return AnyView(ChatView(messageText: "", inputStyle: .default, groupId: groupData.groupID))
		}
		
		return AnyView(ChatGroupContentView(loadable: $loadable, search: .constant([]), getUser: .constant([]), getProfile: .constant(data.getProfile)))
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
