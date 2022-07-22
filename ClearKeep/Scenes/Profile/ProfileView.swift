//
//  ProfileView.swift
//  ClearKeep
//
//  Created by đông on 27/04/2022.
//

import SwiftUI
import Common
import CommonUI

struct ProfileView: View {
	// MARK: - Constants
	private let inspection = ViewInspector<Self>()
	
	// MARK: - Variables
	@Environment(\.injected) private var injected: DIContainer
	@Environment(\.colorScheme) var colorScheme
	@Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
	@State private(set) var loadable: Loadable<IProfileViewModels> = .notRequested
	@State private(set) var profile: UserProfileViewModel?
	// MARK: - Body
	var body: some View {
		content
			.onReceive(inspection.notice) { inspection.visit(self, $0) }
			.hiddenNavigationBarStyle()
			.onAppear(perform: getProfile)
	}
}

// MARK: - Private
private extension ProfileView {
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

// MARK: - Private func
private extension ProfileView {
	func customBack() {
		self.presentationMode.wrappedValue.dismiss()
	}
	
}

// MARK: - Loading Content
private extension ProfileView {
	var notRequestedView: some View {
		UserProfileContentView(loadable: $loadable, myProfile: .constant(nil))
	}
	
	var loadingView: some View {
		notRequestedView.progressHUD(true)
	}
	
	func loadedView(_ data: IProfileViewModels) -> AnyView {
		if let myProfile = data.userProfileViewModel {
			return AnyView(UserProfileContentView(loadable: $loadable, myProfile: .constant(myProfile), urlAvatar: myProfile.avatar))
		}
		
		if let imageData = data.urlAvatarViewModel {
			let myProfile = data.userProfileViewModel
			return AnyView(UserProfileContentView(loadable: $loadable, myProfile: .constant(myProfile), urlAvatar: imageData.fileURL))
		}
		
		return AnyView(UserProfileContentView(loadable: $loadable, myProfile: .constant(nil)))
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
private extension ProfileView {
	func getProfile() {
		loadable = .isLoading(last: nil, cancelBag: CancelBag())
		Task {
			loadable = await injected.interactors.profileInteractor.getProfile()
		}
	}
}

// MARK: - Preview
#if DEBUG
struct ProfileView_Previews: PreviewProvider {
	static var previews: some View {
		ProfileView()
	}
}
#endif
