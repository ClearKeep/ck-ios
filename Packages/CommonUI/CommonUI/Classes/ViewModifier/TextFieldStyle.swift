//
//  TextFieldStyle.swift
//  
//
//  Created by NamNH on 03/03/2022.
//

import SwiftUI

public struct CustomSecureTextField: UIViewRepresentable {

	let placeHolder: String
	@Binding var text: String
	@Binding var isRevealed: Bool
	let isFocused: (Bool) -> Void

	public func makeUIView(context: UIViewRepresentableContext<CustomSecureTextField>) -> UITextField {
		let textfield = UITextField(frame: .zero)
		textfield.placeholder = self.placeHolder
		textfield.isUserInteractionEnabled = true
		textfield.delegate = context.coordinator
		return textfield
	}

	public func makeCoordinator() -> CustomSecureTextField.Coordinator {
		return Coordinator(text: $text, isEnabled: $isRevealed, isFocused: isFocused)
	}

	public func updateUIView(_ uiView: UITextField, context: Context) {
		uiView.isSecureTextEntry = !isRevealed
	}

	public class Coordinator: NSObject, UITextFieldDelegate {
		@Binding var text: String
		let isFocused: (Bool) -> Void

		init(text: Binding<String>, isEnabled: Binding<Bool>, isFocused: @escaping (Bool) -> Void) {
			_text = text
			self.isFocused = isFocused
		}

		public func textFieldDidBeginEditing(_ textField: UITextField) {
			DispatchQueue.main.async {
			   self.isFocused(true)
			}
		}

		public func textFieldDidEndEditing(_ textField: UITextField) {
			DispatchQueue.main.async {
				self.isFocused(false)
			}
		}

		public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
			textField.resignFirstResponder()
			return false
		}
	}
}
