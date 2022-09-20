//
//  BindingExtensions.swift
//  
//
//  Created by NamNH on 04/03/2022.
//

import SwiftUI

extension Binding {
	func onChange(_ handler: @escaping (Value) -> Void) -> Binding<Value> {
		Binding(
			get: { self.wrappedValue },
			set: { newValue in
				self.wrappedValue = newValue
				handler(newValue)
			}
		)
	}
}
