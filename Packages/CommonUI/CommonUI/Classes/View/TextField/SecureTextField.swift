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
	static let paddingText = 4.0
	static let spacingVstack = 2.0
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
	private let onEditingChanged: (Bool) -> Void
	private let submitLabel: SubmitLabel
	private let onSubmit: (() -> Void)
	private let textChange: ((String) -> Void)

	// MARK: - Init
	public init(secureText: Binding<String>,
				inputStyle: Binding<TextInputStyle>,
				inputIcon: Image? = nil,
				placeHolder: String,
				keyboardType: UIKeyboardType = .default,
				onEditingChanged: @escaping (Bool) -> Void,
				submitLabel: SubmitLabel = .continue,
				onSubmit: @escaping (() -> Void) = {},
				textChange: @escaping ((String) -> Void) = { _ in }
	) {
		self._secureText = secureText
		self._inputStyle = inputStyle
		self.inputIcon = inputIcon
		self.placeHolder = placeHolder
		self.keyboardType = keyboardType
		self.onEditingChanged = onEditingChanged
		self.submitLabel = submitLabel
		self.onSubmit = onSubmit
		self.textChange = textChange
	}

	// MARK: - Body
	public var body: some View {
		VStack(alignment: .leading, spacing: Constants.spacingVstack) {
			HStack(alignment: .center) {
				if let inputIcon = inputIcon {
					inputIcon
						.foregroundColor(tintColor)
						.padding(.leading, Constants.paddingHorizontal)
				} else {
					Spacer()
						.frame(width: Constants.spacing)
				}
				CustomSecureTextField(placeHolder: placeHolder,
									  text: $secureText,
									  isRevealed: $isRevealed,
									  isFocused: onEditingChanged,
									  onSubmit: onSubmit, textChange: self.textChange)
					.font(font)
					.foregroundColor(textColor)
					.padding(.vertical, Constants.paddingVertical)
					.padding(.trailing, Constants.spacing)
					.submitLabel(submitLabel)
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
					.lineLimit(2)
					.fixedSize(horizontal: false, vertical: true)
					.padding(.leading, Constants.paddingText)
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
		colorScheme == .light ? inputStyle.notifyColorLight : inputStyle.notifyColorDark
	}

	var font: Font {
		inputStyle.textStyle.font
	}

	var secureIcon: Image {
		isRevealed ? commonUIConfig.imageSet.eyeOff : commonUIConfig.imageSet.eyeOn
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
		SecureTextField(secureText: .constant("Test"), inputStyle: .constant(.error(message: "Error")), placeHolder: "Phone") { _ in }
	}
}
