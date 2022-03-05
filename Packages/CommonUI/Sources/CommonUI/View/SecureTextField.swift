//
//  SwiftUIView.swift
//  
//
//  Created by MinhDev on 04/03/2022.
//

import SwiftUI

private enum Constants {
	static let textFieldHeight = 52.0
	static let notifyHeight = 20.0
}

public struct SecureTextField: View {
	// MARK: - Variables
	@Binding var text: String
	@Binding var inputStyle: TextInputStyle
	let placeHolder: String
//	@Binding var onEditingChanged: Bool

	// MARK: - Init
	public init(text: Binding<String>,
				inputStyle: Binding<TextInputStyle>,
				placeHolder: String )
//				onEditingChanged: @escaping (Bool) -> Void)
	{
		self._text = text
		self._inputStyle = inputStyle
		self.placeHolder = placeHolder
//		self.onEditingChanged = onEditingChanged
	}

	// MARK: - Body
	public var body: some View {
		switch inputStyle {
		case .default:
			SecureField(placeHolder, text: $text)
				.background(inputStyle.backgroundColor)
				.frame(height: Constants.textFieldHeight)
				.foregroundColor(inputStyle.textColor)
				.cornerRadius(inputStyle.cornerRadius)
		case .normal:
			SecureField(placeHolder, text: $text)
				.background(inputStyle.backgroundColor)
				.frame(height: Constants.textFieldHeight)
				.foregroundColor(inputStyle.textColor)
				.cornerRadius(inputStyle.cornerRadius)
		case .disabled:
			SecureField(placeHolder, text: $text)
				.background(inputStyle.backgroundColor)
				.frame(height: Constants.textFieldHeight)
				.cornerRadius(inputStyle.cornerRadius)
		case .highlighted:
			SecureField(placeHolder, text: $text)
				.background(inputStyle.backgroundColor)
				.frame(height: Constants.textFieldHeight)
				.foregroundColor(inputStyle.textColor)
				.cornerRadius(inputStyle.cornerRadius)
		case .error(let message):
			VStack {
				SecureField(placeHolder, text: $text)
					.background(inputStyle.backgroundColor)
					.frame(height: Constants.textFieldHeight)
					.cornerRadius(inputStyle.cornerRadius)
				Text(message).foregroundColor(inputStyle.notifyColor)
			}
		case .success(let message):
			VStack {
				SecureField(placeHolder, text: $text)
					.background(inputStyle.backgroundColor)
					.frame(height: Constants.textFieldHeight)
					.cornerRadius(inputStyle.cornerRadius)
				Text(message).foregroundColor(inputStyle.notifyColor)
			}
		}
	}
}
