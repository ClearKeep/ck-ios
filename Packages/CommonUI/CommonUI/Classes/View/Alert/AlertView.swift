//
//  AlertView.swift
//  _NIODataStructures
//
//  Created by MinhDev on 05/04/2022.
//

import SwiftUI

public extension View {
	func commonAlertView(isPresented: Binding<Bool>,
						 titleMessage: String,
						 bodyMessage: String,
						 primaryTitle: String,
						 dismissButton: Alert.Button? = nil,
						 onAction: @escaping () -> Void) -> some View {

		alert(isPresented: isPresented) {
			Alert(title: Text(titleMessage)
					.font(commonUIConfig.fontSet.font(style: .body2)),
				  message: Text(bodyMessage)
					.font(commonUIConfig.fontSet.font(style: .input3)),
				  dismissButton: .default(Text(primaryTitle),
										  action: onAction))
		}
	}

	func secondaryAlert(isPresented: Binding<Bool>,
						titleMessage: String,
						bodyMessage: String,
						primaryTitle: String,
						secondaryTitle: String,
						primaryButton: Alert.Button? = nil,
						secondaryButton: Alert.Button? = nil,
						onPrimary: @escaping () -> Void,
						onSecondary: @escaping () -> Void) -> some View {

		alert(isPresented: isPresented) {
			Alert(title: Text(titleMessage)
					.font(commonUIConfig.fontSet.font(style: .body2)),
				  message: Text(bodyMessage)
					.font(commonUIConfig.fontSet.font(style: .input3)),
				  primaryButton: .default(Text(primaryTitle), action: onPrimary),
				  secondaryButton: .default(Text(secondaryTitle), action: onSecondary))
		}
	}
}
