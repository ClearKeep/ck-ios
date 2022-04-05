//
//  MultiAlertView.swift
//  _NIODataStructures
//
//  Created by MinhDev on 04/04/2022.
//

import SwiftUI

struct SecondaryAlert: View {
	// MARK: - Variables
	@Binding var titleMessage: String
	@Binding var bodyMessage: String
	@Binding var primaryTitle: String
	@Binding var secondaryTitle: String
	@Binding var isPresented: Bool
	private let onPrimary: () -> Void
	private let onSecondary: () -> Void
	// MARK: - Init
	public init(titleMessage: Binding<String>,
				bodyMessage: Binding<String>,
				primaryTitle: Binding<String>,
				secondaryTitle: Binding<String>,
				isPresented: Binding<Bool>,
				onPrimary:@escaping () -> Void,
				onSecondary:@escaping () -> Void) {
		self._titleMessage = titleMessage
		self._bodyMessage = bodyMessage
		self._primaryTitle = primaryTitle
		self._secondaryTitle = secondaryTitle
		self._isPresented = isPresented
		self.onPrimary = onPrimary
		self.onSecondary = onSecondary
	}
	
	// MARK: - Body
	public var body: some View {
		alert(isPresented: $isPresented) {
			Alert(title: Text(titleMessage)
					.font(fontTitle),
				  message: Text(bodyMessage)
					.font(fontBody),
				  primaryButton: .default(Text(primaryTitle), action: onPrimary),
				  secondaryButton: .default(Text(secondaryTitle), action: onSecondary))
		}
	}
}
	// MARK: - Private func
private extension SecondaryAlert {
	var fontTitle: Font {
		commonUIConfig.fontSet.font(style: .body2)
	}
	
	var fontBody: Font {
		commonUIConfig.fontSet.font(style: .input3)
	}
}

struct SecondaryAlert_Previews: PreviewProvider {
	static var previews: some View {
		SecondaryAlert(titleMessage: .constant(""), bodyMessage: .constant(""), primaryTitle: .constant(""), secondaryTitle: .constant(""), isPresented: .constant(false), onPrimary: { }, onSecondary: {
		})
	}
}
