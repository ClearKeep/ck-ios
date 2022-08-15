//
//  ProfileView.swift
//  ClearKeep
//
//  Created by đông on 27/04/2022.
//

import SwiftUI
import Common
import CommonUI
import PhoneNumberKit

struct ProfileView: View {
	// MARK: - Constants
	private let inspection = ViewInspector<Self>()
	
	// MARK: - Variables
	@Environment(\.injected) private var injected: DIContainer
	@Environment(\.colorScheme) var colorScheme
	@Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
	@State private(set) var loadable: Loadable<IProfileViewModels> = .notRequested {
		didSet {
			switch loadable {
			case .loaded(let data):
				isMfaEnable = data.isMfaEnable
				displayName = data.userProfileViewModel?.displayName ?? ""
				urlAvatar = data.userProfileViewModel?.avatar ?? ""
				email = data.userProfileViewModel?.email ?? ""
				profile = data.userProfileViewModel
				do {
					let phoneNumber = try phoneNumberKit.parse(data.userProfileViewModel?.phoneNumber ?? "")
					countryCode = "+\(phoneNumber.countryCode)"
					number = String(phoneNumber.nationalNumber)
					isHavePhoneNumber = !number.isEmpty
				} catch {
					print("parse phone number error")
					isHavePhoneNumber = false
				}
			default: break
			}
		}
	}
	@State private var countryCode = ""
	@State private var number = ""
	@State private var displayName = ""
	@State private var urlAvatar = ""
	@State private var email = ""
	@State private var isHavePhoneNumber: Bool = false
	@State private var isMfaEnable: Bool = false
	let phoneNumberKit = PhoneNumberKit()
	@State private(set) var profile: UserProfileViewModel?
	// MARK: - Body
	var body: some View {
		content
			.onReceive(inspection.notice) { inspection.visit(self, $0) }
			.hiddenNavigationBarStyle()
			.onAppear(perform: getProfile)
			.hideKeyboardOnTapped()
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
			return AnyView(loadedView(data: data))
		case .failed(let error):
			return AnyView(errorView(ProfileErrorView(error)))
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
		UserProfileContentView(countryCode: $countryCode,
							   loadable: $loadable,
							   urlAvatar: $urlAvatar,
							   username: $displayName,
							   email: $email,
							   phoneNumber: $number,
							   isHavePhoneNumber: $isHavePhoneNumber,
							   isEnable2FA: $isMfaEnable,
							   profile: profile)
	}
	
	var loadingView: some View {
		notRequestedView.progressHUD(true)
	}
	
	func loadedView(data: IProfileViewModels) -> some View {
		return notRequestedView
	}
	
	func errorView(_ error: ProfileErrorView) -> some View {
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
