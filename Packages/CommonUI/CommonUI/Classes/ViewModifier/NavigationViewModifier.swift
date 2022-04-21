//
//  NavigationViewModifier.swift
//  CommonUI
//
//  Created by đông on 19/04/2022.
//

import SwiftUI

struct NavigationModifier: ViewModifier {
	// MARK: - Body
	func body(content: Content) -> some View {
		content
			.navigationBarTitle("")
			.navigationBarHidden(true)
	}
}
