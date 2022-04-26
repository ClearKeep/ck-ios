//
//  Extension.swift
//  _NIODataStructures
//
//  Created by MinhDev on 26/04/2022.
//

import SwiftUI

#if canImport(UIKit)
extension View {
	func hideKeyboard() {
		UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
	}
}
#endif
