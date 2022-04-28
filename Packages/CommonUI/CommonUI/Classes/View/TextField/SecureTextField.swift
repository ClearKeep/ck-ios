//
//  SecureTextField.swift
//
//
//  Created by NamNH on 05/03/2022.
//

// swiftlint:disable multiple_closures_with_trailing_closure

import SwiftUI

private enum Constants {
	static let textFieldHeight = 52.0
	static let notifyHeight = 22.0
	static let paddingVertical = 14.0
	static let paddingHorizontal = 24.0
	static let spacing = 14.0
}

public struct SecureTextField: View {
	// MARK: - Variables
	@Environment(\.colorScheme) var colorScheme
	@Binding var secureText: String
	@Binding var inputStyle: TextInputStyle
	@State private var isRevealed = false
	private let inputIcon: Image?
	private let placeHolder: String
	private let keyboardType: UIKeyboardType

	// MARK: - Init
	public init(secureText: Binding<String>,
				inputStyle: Binding<TextInputStyle>,
				inputIcon: Image? = nil,
				placeHolder: String,
				keyboardType: UIKeyboardType = .default) {
		self._secureText = secureText
		self._inputStyle = inputStyle
		self.inputIcon = inputIcon
		self.placeHolder = placeHolder
		self.keyboardType = keyboardType
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
				SecureField(placeHolder, text: $secureText)
					.font(font)
					.foregroundColor(textColor)
					.padding(.vertical, Constants.paddingVertical)
					.padding(.trailing, Constants.spacing)
				Button(action: { isRevealed.toggle() }) {
					secureIcon
						.foregroundColor(tintColor)
						.padding(.trailing, Constants.paddingHorizontal)
				}
			}
			.frame(height: Constants.textFieldHeight)
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
private extension SecureTextField {
	var backgroundColor: Color {
		colorScheme == .light ? inputStyle.backgroundColorLight : inputStyle.backgroundColorDark
	}

	var tintColor: Color {
		colorScheme == .light ? inputStyle.tintColorLight : inputStyle.tintColorDark
	}

	var borderColor: Color {
		colorScheme == .light ? inputStyle.borderColorLight : inputStyle.borderColorDark
	}

	var borderWidth: CGFloat {
		inputStyle.borderWidth
	}

	var cornerRadius: CGFloat {
		inputStyle.cornerRadius
	}

	var textColor: Color {
		colorScheme == .light ? inputStyle.textColorLight : inputStyle.textColorDark
	}

	var notifyColor: Color {
		colorScheme == .light ? inputStyle.notifyColorLight : inputStyle.notifyColorLight
	}

	var font: Font {
		inputStyle.textStyle.font
	}

	var secureIcon: Image {
		isRevealed ? commonUIConfig.imageSet.eyeOn : commonUIConfig.imageSet.eyeOff
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

struct SecureTextField_Previews: PreviewProvider {
	static var previews: some View {
		SecureTextField(secureText: .constant("Test"), inputStyle: .constant(.error(message: "Error")), placeHolder: "Phone")
	}
}
