//
//  CommonTextField.swift
//  
//
//  Created by NamNH on 03/03/2022.
//

import SwiftUI

private enum Constants {
	static let textFieldHeight = 52.0
	static let notifyHeight = 22.0
	static let paddingVertical = 14.0
	static let paddingHorizontal = 24.0
	static let spacing = 14.0
}

public struct CommonTextField: View {
	// MARK: - Variables
	@Binding var text: String
	@Binding var inputStyle: TextInputStyle
	private let inputIcon: Image?
	private let placeHolder: String
	private let keyboardType: UIKeyboardType
	private let onEditingChanged: (Bool) -> Void
	
	// MARK: - Init
	public init(text: Binding<String>,
				inputStyle: Binding<TextInputStyle>,
				inputIcon: Image? = nil,
				placeHolder: String,
				keyboardType: UIKeyboardType = .default,
				onEditingChanged: @escaping (Bool) -> Void) {
		self._text = text
		self._inputStyle = inputStyle
		self.inputIcon = inputIcon
		self.placeHolder = placeHolder
		self.keyboardType = keyboardType
		self.onEditingChanged = onEditingChanged
	}
	
	// MARK: - Body
	public var body: some View {
		VStack(spacing: 2.0) {
			HStack(alignment: .center) {
				if let inputIcon = inputIcon {
					inputIcon
						.foregroundColor(tintColor)
						.padding(.leading, Constants.paddingHorizontal)
				} else {
					Spacer()
						.frame(width: Constants.spacing)
				}
				TextField(placeHolder, text: $text, onEditingChanged: onEditingChanged)
					.font(font)
					.foregroundColor(textColor)
					.padding(.vertical, Constants.paddingVertical)
					.padding(.trailing, Constants.paddingHorizontal)
			}
			.frame(height: Constants.textFieldHeight)
			.padding()
			.background(backgroundColor)
			.cornerRadius(cornerRadius)
			.overlay(
				RoundedRectangle(cornerRadius: cornerRadius)
					.stroke(borderColor, lineWidth: borderWidth)
			)
			if needShowNotifiyMessage {
				Text(notifiyMessage)
					.font(font)
					.frame(height: Constants.notifyHeight)
					.foregroundColor(notifyColor)
			}
		}
	}
}

// MARK: - Private func
private extension CommonTextField {
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
	
	var textColor: Color {
		inputStyle.textColor
	}
	
	var notifyColor: Color {
		inputStyle.notifyColor
	}
	
	var font: Font {
		inputStyle.textStyle.font
	}
	
	var needShowNotifiyMessage: Bool {
		switch inputStyle {
		case .error, .success: return true
		default: return false
		}
	}
	
	var notifiyMessage: String {
		switch inputStyle {
		case .error(let message), .success(let message): return message
		default: return ""
		}
	}
}

struct CommonTextField_Previews: PreviewProvider {
	static var previews: some View {
		CommonTextField(text: .constant("Test"), inputStyle: .constant(.error(message: "Error")), placeHolder: "Phone") { _ in
			
		}
	}
}
