//
//  MultiLineTextField.swift
//
//
//  Created by NamNH on 20/03/2022.
//

import SwiftUI

private enum Constants {
	static let minHeight = 44.0
	static let maxLine = 5.0
}

struct MultilineTextField: View {
	// MARK: - Variables
	private var placeholder: String
	@Binding private var text: String

	// MARK: - Init
	init (placeholder: String = "", text: Binding<String>) {
		self.placeholder = placeholder
		self._text = text
	}

	// MARK: - Body
	var body: some View {
		HStack {
			TextEditor(text: $text)
				.background(placeholderView)
				.frame(minHeight: Constants.minHeight, maxHeight: Constants.minHeight * Constants.maxLine)
			Button(action: {

			}, label: {
				Image("ic_emoji")
					.foregroundColor(commonUIConfig.colorSet.grey1)
			})
		}
	}

	var placeholderView: some View {
		Group {
			if self.text.isEmpty {
				Text(placeholder).foregroundColor(commonUIConfig.colorSet.grey3)
					.padding(.leading, 4)
					.padding(.top, 8)
			}
		}
	}
}
