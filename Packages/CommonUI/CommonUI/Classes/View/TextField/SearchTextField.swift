//
//  SearchTextField.swift
//
//
//  Created by NamNH on 03/03/2022.
//

// swiftlint:disable multiple_closures_with_trailing_closure

import SwiftUI

private enum Constants {
	static let textFieldHeight = 52.0
	static let paddingVertical = 14.0
	static let paddingHorizontal = 24.0
	static let spacing = 14.0
}

public struct SearchTextField: View {
	// MARK: - Variables
	@Environment(\.colorScheme) var colorScheme
	@Binding var searchText: String
	@Binding var inputStyle: TextInputStyle
	@State private var shouldShowCancelButton: Bool = false
	private let inputIcon: Image?
	private let placeHolder: String
	private let keyboardType: UIKeyboardType
	private let onEditingChanged: (Bool) -> Void
	private let onSubmit: (() -> Void)
	private let submitLabel: SubmitLabel

	// MARK: - Init
	public init(searchText: Binding<String>,
				inputStyle: Binding<TextInputStyle>,
				inputIcon: Image? = nil,
				placeHolder: String,
				keyboardType: UIKeyboardType = .default,
				onEditingChanged: @escaping (Bool) -> Void,
				onSubmit: @escaping (() -> Void) = {},
				submitLabel: SubmitLabel = .continue) {
		self._searchText = searchText
		self._inputStyle = inputStyle
		self.inputIcon = inputIcon
		self.placeHolder = placeHolder
		self.keyboardType = keyboardType
		self.onEditingChanged = onEditingChanged
		self.onSubmit = onSubmit
		self.submitLabel = submitLabel
	}

	// MARK: - Body
	public var body: some View {
		HStack(alignment: .center) {
			if let inputIcon = inputIcon {
				inputIcon
					.foregroundColor(tintColor)
					.padding(.leading, Constants.paddingHorizontal)
			} else {
				Spacer()
					.frame(width: Constants.spacing)
			}
			TextField(placeHolder, text: $searchText, onEditingChanged: onEditingChanged)
				.onChange(of: searchText) {
					shouldShowCancelButton = $0.count > 0
				}
				.submitLabel(submitLabel)
				.onSubmit(self.onSubmit)
				.font(font)
				.foregroundColor(textColor)
				.padding(.vertical, Constants.paddingVertical)
				.padding(.trailing, Constants.spacing)
				.autocapitalization(.none)
			if shouldShowCancelButton {
				Button(action: { searchText = "" }) {
					commonUIConfig.imageSet.closeIcon
						.foregroundColor(tintColor)
						.padding(.trailing, Constants.paddingHorizontal)
				}
			}
		}
		.frame(height: Constants.textFieldHeight)
		.background(backgroundColor)
		.cornerRadius(cornerRadius)
		.overlay(
			RoundedRectangle(cornerRadius: cornerRadius)
				.stroke(borderColor, lineWidth: borderWidth)
		)
	}
}

// MARK: - Private func
private extension SearchTextField {
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
}

struct SearchTextField_Previews: PreviewProvider {
	static var previews: some View {
		SearchTextField(searchText: .constant("Test"), inputStyle: .constant(.default), placeHolder: "Phone") { _ in }
	}
}
