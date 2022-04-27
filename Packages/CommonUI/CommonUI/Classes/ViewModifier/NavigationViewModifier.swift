//
//  NavigationViewModifier.swift
//  CommonUI
//
//  Created by đông on 19/04/2022.
//

import SwiftUI

public struct NavigationModifier: ViewModifier {
	// MARK: - Body
	public init() { }
	public func body(content: Content) -> some View {
		content
			.navigationBarTitle("")
			.navigationBarHidden(true)
	}
}
