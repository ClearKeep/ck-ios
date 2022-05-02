//
//  CurrentPassword.swift
//  ClearKeep
//
//  Created by đông on 29/04/2022.
//

import SwiftUI
import Combine
import Common
import CommonUI

struct CurrentPassword: View {
	@Environment(\.presentationMode) var presentationMode
	@Environment(\.injected) private var injected: DIContainer
	@Environment(\.colorScheme) var colorScheme
	@State private(set) var currentPassword: String
	@State private(set) var currentPasswordStyle: TextInputStyle = .default
	@State private(set) var currentPasswordCommonStyle: SocialCommonStyle = .currentPassword

	// MARK: - Init
	init(samples: Loadable<[ISocialModel]> = .notRequested,
		 currentPassword: String = "",
		 inputStyle: TextInputStyle = .default,
		 socialStyle: SocialCommonStyle = .currentPassword) {
		self._currentPassword = .init(initialValue: currentPassword)
		self._currentPasswordStyle = .init(initialValue: currentPasswordStyle)
	}

	// MARK: - Body
	var body: some View {
		SocialCommonUI(text: $currentPassword, socialStyle: $currentPasswordCommonStyle)
			.onDisappear {
				currentPassword = ""
			}
	}
}

struct CurrentPassword_Previews: PreviewProvider {
	static var previews: some View {
        CurrentPassword()
    }
}
