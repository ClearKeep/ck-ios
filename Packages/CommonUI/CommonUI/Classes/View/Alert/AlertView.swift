//
//  AlertView.swift
//  _NIODataStructures
//
//  Created by MinhDev on 05/04/2022.
//

import SwiftUI

public extension View {
	func CommonAlertView(isPresented: Binding<Bool>,
						 titleMessage: String,
						 bodyMessage: String,
						 primaryTitle: String,
						 dismissButton: Alert.Button? = nil,
						 onAction: @escaping () -> Void) -> some View {

		alert(isPresented: isPresented) {
			Alert(title: Text(titleMessage),
				  message: Text(bodyMessage),
				  dismissButton: .default(Text(primaryTitle),
										  action: onAction))
		}
	}

	func SecondaryAlert(isPresented: Binding<Bool>,
					 title: String,
					 message: String? = nil,
					 title2: String,
					 dismissButton: Alert.Button? = nil) -> some View {

		alert(isPresented: isPresented) {
			Alert(title: Text(title),
				  message: {
				if let message = message { return Text(message) }
				else { return nil } }(),
				  dismissButton: .default(Text(title2)))
		}
	}
}
