//
//  CommonTextField.swift
//  
//
//  Created by NamNH on 03/03/2022.
//

import SwiftUI

private enum Constants {
	static let textFieldHeight = 52.0
	static let notifyHeight = 20.0
}

public struct CommonTextField: View {
	// MARK: - Variables
	@Binding var text: String
	@Binding var inputStyle: TextInputStyle
	let placeHolder: String
	let onEditingChanged: (Bool) -> Void
	
	// MARK: - Init
	public init(text: Binding<String>,
				inputStyle: Binding<TextInputStyle>,
				placeHolder: String,
				onEditingChanged: @escaping (Bool) -> Void) {
		self._text = text
		self._inputStyle = inputStyle
		self.placeHolder = placeHolder
		self.onEditingChanged = onEditingChanged
	}
	
	// MARK: - Body
	public var body: some View {
		switch inputStyle {
		case .default:
			TextField(placeHolder, text: $text, onEditingChanged: onEditingChanged)
				.background(inputStyle.backgroundColor)
				.frame(height: Constants.textFieldHeight)
				.cornerRadius(inputStyle.cornerRadius)
		case .normal:
			TextField(placeHolder, text: $text, onEditingChanged: onEditingChanged)
				.background(inputStyle.backgroundColor)
				.frame(height: Constants.textFieldHeight)
				.cornerRadius(inputStyle.cornerRadius)
		case .disabled:
			TextField(placeHolder, text: $text, onEditingChanged: onEditingChanged)
				.background(inputStyle.backgroundColor)
				.frame(height: Constants.textFieldHeight)
				.cornerRadius(inputStyle.cornerRadius)
		case .highlighted:
			TextField(placeHolder, text: $text, onEditingChanged: onEditingChanged)
				.background(inputStyle.backgroundColor)
				.frame(height: Constants.textFieldHeight)
				.cornerRadius(inputStyle.cornerRadius)
		case .error(let message):
			VStack {
				TextField(placeHolder, text: $text, onEditingChanged: onEditingChanged)
					.background(inputStyle.backgroundColor)
					.frame(height: Constants.textFieldHeight)
					.cornerRadius(inputStyle.cornerRadius)
				Text(message).foregroundColor(inputStyle.notifyColor)
			}
		case .success(let message):
			VStack {
				TextField(placeHolder, text: $text, onEditingChanged: onEditingChanged)
					.background(inputStyle.backgroundColor)
					.frame(height: Constants.textFieldHeight)
					.cornerRadius(inputStyle.cornerRadius)
				Text(message).foregroundColor(inputStyle.notifyColor)
			}
		}
	}
}

struct CommonTextField_Previews: PreviewProvider {
	static var previews: some View {
		CommonTextField(text: .constant("Test"), inputStyle: .constant(.error(message: "Error")), placeHolder: "Phone") { _ in
			
		}
	}
}
