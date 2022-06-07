//
//  Extension.swift
//  _NIODataStructures
//
//  Created by MinhDev on 26/04/2022.
//

import SwiftUI

#if canImport(UIKit)
extension View {
	public func hideKeyboard() {
		UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
	}
	
	public func hideKeyboardOnTapped() -> some View {
		return self.onTapGesture {
			hideKeyboard()
		}
	}
}
#endif

public extension View {
	/// Applies the given transform if the given condition evaluates to `true`.
	/// - Parameters:
	///   - condition: The condition to evaluate.
	///   - transform: The transform to apply to the source `View`.
	/// - Returns: Either the original `View` or the modified `View` if the condition is `true`.
	@ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
		if condition {
			transform(self)
		} else {
			self
		}
	}
	
	func bottomSheet<Content: View>(
		isPresented: Binding<Bool>,
		isShowHandle: Bool,
		@ViewBuilder content: @escaping () -> Content
	) -> some View {
		self
			.overlay(
				Group {
					if isPresented.wrappedValue {
						BottomSheet(
							isPresented: isPresented,
							content: content,
							isShowHandle: isShowHandle
						)
					}
				}
			)
	}
}
