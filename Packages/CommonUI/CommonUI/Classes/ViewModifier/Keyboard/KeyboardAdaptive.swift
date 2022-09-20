//
//  AdaptsToKeyboard.swift
//  CommonUI
//
//  Created by NamNH on 06/05/2022.
//

import SwiftUI
import Combine

struct KeyboardAdaptive: ViewModifier {
	@State private var keyboardHeight: CGFloat = 0

	func body(content: Content) -> some View {
		content
			.padding(.bottom, keyboardHeight)
			.onReceive(Publishers.keyboardHeight) { self.keyboardHeight = $0 }
	}
}

extension View {
	public func keyboardAdaptive() -> some View {
		ModifiedContent(content: self, modifier: KeyboardAdaptive())
	}
}

extension Publishers {
	static var keyboardHeight: AnyPublisher<CGFloat, Never> {

		let willShow = NotificationCenter.default.publisher(for: UIApplication.keyboardWillShowNotification)
			.map { $0.keyboardHeight }
		
		let willHide = NotificationCenter.default.publisher(for: UIApplication.keyboardWillHideNotification)
			.map { _ in CGFloat(0) }
		
		return MergeMany(willShow, willHide)
			.eraseToAnyPublisher()
	}
}

extension Notification {
	var keyboardHeight: CGFloat {
		return (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect)?.height ?? 0
	}
}
