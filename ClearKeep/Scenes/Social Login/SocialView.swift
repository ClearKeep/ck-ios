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
	
	// MARK: - Body
	var body: some View {
		SocialCommonUI(text: $security, socialStyle: $socialCommonStyle)
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
