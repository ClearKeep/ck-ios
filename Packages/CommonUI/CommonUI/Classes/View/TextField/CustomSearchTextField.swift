//
//  CustomSearchTextField.swift
//  CommonUI
//
//  Created by MinhDev on 16/06/2022.
//

import UIKit
import SwiftUI

public struct CustomSearchTextField: UIViewRepresentable {
	let placeHolder: String
	@Binding var text: String
	let isFocused: (Bool) -> Void
	var onTextChanged: (String) -> Void

	public func makeUIView(context: UIViewRepresentableContext<CustomSearchTextField>) -> UITextField {
		let textField = UITextField(frame: .zero)
		textField.placeholder = placeHolder
		textField.isUserInteractionEnabled = true
		textField.delegate = context.coordinator
		textField.autocapitalizationType = .none
		return textField
	}

	public func makeCoordinator() -> CustomSearchTextField.Coordinator {
		return Coordinator(text: $text, isFocused: isFocused, onTextChanged: onTextChanged)
	}

	public func updateUIView(_ uiView: UITextField, context: Context) {
		uiView.text = text
	}

	public class Coordinator: NSObject, UITextFieldDelegate {
		@Binding var text: String
		let isFocused: (Bool) -> Void
		var onTextChanged: (String) -> Void

		init(text: Binding<String>, isFocused: @escaping (Bool) -> Void, onTextChanged: @escaping (String) -> Void) {
			_text = text
			self.isFocused = isFocused
			self.onTextChanged = onTextChanged
		}

		public func textFieldDidBeginEditing(_ textField: UITextField) {
			$text.wrappedValue = textField.text ?? ""
			self.isFocused(true)
		}

		public func textFieldDidEndEditing(_ textField: UITextField) {
			$text.wrappedValue = textField.text ?? ""
			self.isFocused(false)
		}

		public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
			textField.resignFirstResponder()
			return false
		}

		public func textFieldDidChangeSelection(_ textField: UITextField) {
			$text.wrappedValue = textField.text ?? ""
		}

		public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
			onTextChanged(text)
			return true
		}
	}
}
