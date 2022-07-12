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
	
	// MARK: - Init

	// MARK: - Body
	var body: some View {
		content
			.onReceive(inspection.notice) { inspection.visit(self, $0) }
			.edgesIgnoringSafeArea(.all)
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
			return AnyView(errorView(LoginViewError(error)))
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
		DirectMessageContentView(loadable: $loadable, userData: .constant([]), profile: .constant(nil))
	}

	var loadingView: some View {
		notRequestedView.progressHUD(true)
	}

	func loadedView(_ data: ICreatePeerViewModels) -> AnyView {
		if let searchUser = data.searchUser {
			let userData = searchUser.sorted(by: { $0.displayName.lowercased().prefix(1) < $1.displayName.lowercased().prefix(1) })
			return AnyView(DirectMessageContentView(loadable: $loadable, userData: .constant(userData), profile: .constant(data.getProfile)))
		}

		if let groupData = data.creatGroup {
			return AnyView(ChatView(messageText: "", inputStyle: .default, groupId: groupData.groupID))
		}

		return AnyView(DirectMessageContentView(loadable: $loadable, userData: .constant([]), profile: .constant(nil)))
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
private extension CreateDirectMessageView {
}

// MARK: - Preview
#if DEBUG
struct CreateDirectMessageView_Previews: PreviewProvider {
	static var previews: some View {
		CreateDirectMessageView()
	}
}
#endif
