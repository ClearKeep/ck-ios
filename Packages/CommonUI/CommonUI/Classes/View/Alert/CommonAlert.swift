//
//  CommonAlertView.swift
//  _NIODataStructures
//
//  Created by MinhDev on 04/04/2022.
//

import SwiftUI

public struct CommonAlert: View {
	// MARK: - Variables
	private let titleMessage: String
	private let bodyMessage: String
	private let primaryTitle: String
	@Binding var isPresented: Bool
	private let onAction: () -> Void
	// MARK: - Init
	public init(titleMessage: String,
				bodyMessage: String,
				primaryTitle: String,
				isPresented: Binding<Bool>,
				onAction:@escaping () -> Void) {
		self.titleMessage = titleMessage
		self.bodyMessage = bodyMessage
		self.primaryTitle = primaryTitle
		self._isPresented = isPresented
		self.onAction = onAction
	}

	// MARK: - Body
	public var body: some View {
		alert(isPresented: $isPresented) {
			Alert(title: Text(titleMessage)
					.font(fontTitle),
				  message: Text(bodyMessage)
					.font(fontBody),
				  dismissButton: .default(Text(primaryTitle),
										  action: onAction))
		}
	}
}
	// MARK: - Private func
private extension CommonAlert {
	var fontTitle: Font {
		commonUIConfig.fontSet.font(style: .body2)
	}

	var fontBody: Font {
		commonUIConfig.fontSet.font(style: .input3)
	}
}

struct CommonAlert_Previews: PreviewProvider {
	static var previews: some View {
		CommonAlert(titleMessage: "", bodyMessage: "", primaryTitle: "", isPresented: .constant(false)) {
		}
	}
}
