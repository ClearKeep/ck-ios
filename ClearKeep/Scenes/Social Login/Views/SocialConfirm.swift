//
//  ConfirmSocial.swift
//  ClearKeep
//
//  Created by đông on 09/03/2022.
//

import SwiftUI
import Combine
import Common
import CommonUI

struct SocialConfirm: View {
	// MARK: - Variables
	@Environment(\.presentationMode) var presentationMode
	@Environment(\.injected) private var injected: DIContainer
	@Environment(\.colorScheme) var colorScheme
	@State private(set) var security: String
	@State private(set) var securityStyle: TextInputStyle = .default
	@State private(set) var socialCommonStyle: SocialCommonStyle = .confirmSecurity
	
	// MARK: - Init
	init(samples: Loadable<[ISocialModel]> = .notRequested,
		 security: String = "",
		 inputStyle: TextInputStyle = .default,
		 socialStyle: SocialCommonStyle = .confirmSecurity) {
		self._security = .init(initialValue: security)
		self._securityStyle = .init(initialValue: securityStyle)
	}
	
	// MARK: - Body
	var body: some View {
		SocialCommonUI(text: $security, socialStyle: $socialCommonStyle)
	}
}

// MARK: - Private Func
private extension SocialConfirm {
	func customBack() {
		self.presentationMode.wrappedValue.dismiss()
	}
}

struct SocialConfirm_Previews: PreviewProvider {
	static var previews: some View {
		SocialConfirm(security: "")
	}
}
