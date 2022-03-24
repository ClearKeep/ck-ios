//
//  PasscodeTextField.swift
//  CommonUI
//
//  Created by đông on 23/03/2022.
//

import SwiftUI

private enum Constants {
	static let textFieldHeight = 52.0
	static let notifyHeight = 22.0
	static let paddingVertical = 14.0
	static let paddingHorizontal = 24.0
	static let spacing = 14.0
	static let widthPasscodeInput = 56.0
	static let heightPasscodeInput = 56.0
}

public struct PasscodeTextField: View {
	// MARK: - Variables
	@Binding var text: String
	@Binding var inputStyle: TextInputStyle
	private let keyboardType: UIKeyboardType

	// MARK: - Init
	public init(text: Binding<String>,
				inputStyle: Binding<TextInputStyle>,
				keyboardType: UIKeyboardType = .numberPad) {
		self._text = text
		self._inputStyle = inputStyle
		self.keyboardType = keyboardType
	}

	// MARK: - Body
	public var body: some View {
		TextField("", text: $text)
			.font(font)
			.foregroundColor(textColor)
			.frame(width: Constants.widthPasscodeInput, height: Constants.heightPasscodeInput)
			.background(backgroundColor)
			.cornerRadius(cornerRadiusPasscode)
	}
}

// MARK: - Private func
private extension PasscodeTextField {
	var backgroundColor: Color {
		inputStyle.backgroundColor
	}

	var tintColor: Color {
		inputStyle.tintColor
	}

	var borderColor: Color {
		inputStyle.borderColor
	}

	var borderWidth: CGFloat {
		inputStyle.borderWidth
	}

	var cornerRadius: CGFloat {
		inputStyle.cornerRadius
	}

	var cornerRadiusPasscode: CGFloat {
		inputStyle.cornerRadiusPasscode
	}

	var textColor: Color {
		inputStyle.textColor
	}

	var notifyColor: Color {
		inputStyle.notifyColor
	}

	var font: Font {
		inputStyle.textStyle.font
	}
}

struct PasscodeTextField_Previews: PreviewProvider {
	static var previews: some View {
		PasscodeTextField(text: .constant("Test"), inputStyle: .constant(.error(message: "Error")))
    }
}
