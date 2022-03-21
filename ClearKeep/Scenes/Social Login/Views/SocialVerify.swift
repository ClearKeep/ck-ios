//
//  SocialThanos.swift
//  ClearKeep
//
//  Created by đông on 09/03/2022.
//

import SwiftUI
import Combine
import Common
import CommonUI

struct SocialVerify: View {
	@Environment(\.presentationMode) var presentationMode
	@Environment(\.injected) private var injected: DIContainer
	@Environment(\.colorScheme) var colorScheme
	@State private(set) var security: String
	@State private(set) var securityStyle: TextInputStyle = .default
	@State private(set) var socialCommonStyle: SocialCommonStyle = .verifySecurity
	
	// MARK: - Init
	init(samples: Loadable<[ISocialModel]> = .notRequested,
		 security: String = "",
		 inputStyle: TextInputStyle = .default,
		 socialStyle: SocialCommonStyle = .verifySecurity) {
		self._security = .init(initialValue: security)
		self._securityStyle = .init(initialValue: securityStyle)
	}
	
	var body: some View {
		SocialCommonUI(text: $security, socialStyle: $socialCommonStyle)
	}
}

// MARK: - Private Func
private extension SocialVerify {
	func customBack() {
		self.presentationMode.wrappedValue.dismiss()
	}
}

struct SocialVerify_Previews: PreviewProvider {
	static var previews: some View {
		SocialVerify()
	}
}
