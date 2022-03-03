//
//  SearchTextField.swift
//  
//
//  Created by NamNH on 03/03/2022.
//

import SwiftUI

import SwiftUI

private enum Constants {
	static let textFieldHeight = 52.0
	static let notifyHeight = 20.0
	static let imageFrame = CGSize(width: 24.0, height: 24.0)
}

public struct SearchTextField: View {
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
		HStack {
			commonUIConfig.imageSet.searchIcon
				.frame(width: Constants.imageFrame.width, height: Constants.imageFrame.height)
				.padding()
			switch inputStyle {
			case .highlighted:
				TextField(placeHolder, text: $text, onEditingChanged: onEditingChanged)
					.background(inputStyle.backgroundColor)
					.frame(height: Constants.textFieldHeight)
					.cornerRadius(inputStyle.cornerRadius)
			default:
				TextField(placeHolder, text: $text, onEditingChanged: onEditingChanged)
					.background(inputStyle.backgroundColor)
					.frame(height: Constants.textFieldHeight)
					.cornerRadius(inputStyle.cornerRadius)
			}
		}
	}
}

struct SearchTextField_Previews: PreviewProvider {
	static var previews: some View {
		SearchTextField(text: .constant("Test"), inputStyle: .constant(.error(message: "Error")), placeHolder: "Phone") { _ in
			
		}
	}
}
