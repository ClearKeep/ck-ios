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
	@State private(set) var loadable: Loadable<IProfileViewModels> = .notRequested
	@State private var countryCode = ""
	@State private var number = ""
	@State private var displayName = ""
	@State private var urlAvatar = ""
	@State private var email = ""
	@State private var isHavePhoneNumber: Bool = false
	@State private var isMfaEnable: Bool = false
	let phoneNumberKit = PhoneNumberKit()
	@State private(set) var profile: UserProfileViewModel?
	@State private var showLoading: Bool = false
	@State private var showError: Bool = false
	@State private var error: ProfileErrorView?
	@State private var isGetProfile: Bool = false
	
	// MARK: - Body
	var body: some View {
		UserProfileContentView(countryCode: $countryCode,
							   urlAvatar: $urlAvatar,
							   username: $displayName,
							   email: $email,
							   phoneNumber: $number,
							   isHavePhoneNumber: $isHavePhoneNumber,
							   isEnable2FA: $isMfaEnable,
							   showLoading: $showLoading,
							   showError: $showError,
							   error: $error,
							   profile: profile)
			.onReceive(inspection.notice) { inspection.visit(self, $0) }
			.onAppear(perform: getProfile)
			.hideKeyboardOnTapped()
			.progressHUD(showLoading)
			.alert(isPresented: $showError) {
				Alert(title: Text(error?.title ?? ""),
					  message: Text(error?.message ?? ""),
					  dismissButton: .default(Text(error?.primaryButtonTitle ?? "")))
			}
	}
}

// MARK: - Private func
private extension ProfileView {
	func customBack() {
		self.presentationMode.wrappedValue.dismiss()
	}
	
}

// MARK: - Interactor
private extension ProfileView {
	func getProfile() {
		if self.isGetProfile {
			return
		}
		self.showLoading = true
		Task {
			let loadable = await injected.interactors.profileInteractor.getProfile()
			
			switch loadable {
			case .loaded(let data):
				self.isGetProfile = true
				self.showLoading = false
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
				if !(data.urlAvatarViewModel?.fileURL.isEmpty ?? true) {
					urlAvatar = data.urlAvatarViewModel?.fileURL ?? ""
				}
			case .failed(let error):
				self.showLoading = false
				self.error = ProfileErrorView(error)
				self.showError = true
			default:
				self.showLoading = false
			}
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
