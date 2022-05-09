//
//  NavigationViewModifier.swift
//  CommonUI
//
//  Created by đông on 19/04/2022.
//

import SwiftUI

public struct HiddenNavigationBar: ViewModifier {
	// MARK: - Body
	public init() { }
	public func body(content: Content) -> some View {
		content
			.navigationBarHidden(true)
			.navigationBarTitle("", displayMode: .inline)
			.navigationBarBackButtonHidden(true)
	}
}

public extension View {
	func hiddenNavigationBarStyle() -> some View {
		modifier( HiddenNavigationBar() )
	}
}
