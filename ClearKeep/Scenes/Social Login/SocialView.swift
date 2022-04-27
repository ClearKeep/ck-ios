//
//  SocialView.swift
//  ClearKeep
//
//  Created by đông on 08/03/2022.
//

import SwiftUI
import Combine
import Common
import CommonUI

struct SocialView: View {
	// MARK: - Variables
	@Environment(\.injected) private var injected: DIContainer
	@Environment(\.colorScheme) var colorScheme
	@Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
	@State private(set) var security: String
	@State private(set) var securityStyle: TextInputStyle = .default
	@State private(set) var socialCommonStyle: SocialCommonStyle = .setSecurity

	// MARK: - Init
	public init(samples: Loadable<[ISocialModel]> = .notRequested,
				security: String = "") {
		self._security = .init(initialValue: security)
	}
	// MARK: - Body
	var body: some View {
		NavigationView {
		SocialCommonUI(text: $security, socialStyle: $socialCommonStyle)
				.navigationBarTitle("")
				.navigationBarHidden(true)
		}
	}
}

// MARK: - Preview
#if DEBUG
struct SocialView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView(container: .preview)

	}
}
#endif
