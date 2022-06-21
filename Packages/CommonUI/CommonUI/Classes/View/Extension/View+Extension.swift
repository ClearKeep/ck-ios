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
	
	/// Presents a bottomSheet when a binding to a Boolean value that you provide is true.
	public func bottomSheet<Content: View>(
		isPresented: Binding<Bool>,
		detents: BottomSheet.Detents = .medium,
		shouldScrollExpandSheet: Bool = true,
		largestUndimmedDetent: BottomSheet.LargestUndimmedDetent? = nil,
		showGrabber: Bool = false,
		cornerRadius: CGFloat? = nil,
		@ViewBuilder content: @escaping () -> Content
	) -> some View {
		background {
			Color.clear
				.onChange(of: isPresented.wrappedValue) { show in
					if show {
						BottomSheet.present(
							detents: detents,
							shouldScrollExpandSheet: shouldScrollExpandSheet,
							largestUndimmedDetent: largestUndimmedDetent,
							showGrabber: showGrabber,
							cornerRadius: cornerRadius
						) {
							content()
								.onDisappear {
									isPresented.projectedValue.wrappedValue = false
								}
						}
					}
				}
		}
	}
	
}
