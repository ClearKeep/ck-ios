//
//  SearchTextField.swift
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

public struct SearchTextField: View {
	// MARK: - Variables
	@Binding var searchText: String
	@Binding var inputStyle: TextInputStyle
	@State private var shouldShowCancelButton: Bool = false
	private let inputIcon: Image?
	private let placeHolder: String
	private let keyboardType: UIKeyboardType
	private let onEditingChanged: (Bool) -> Void
	private let onCancelHandler: () -> Void
	
	// MARK: - Init
	public init(searchText: Binding<String>,
				inputStyle: Binding<TextInputStyle>,
				inputIcon: Image? = nil,
				placeHolder: String,
				keyboardType: UIKeyboardType = .default,
				onEditingChanged: @escaping (Bool) -> Void,
				onCancelHandler: @escaping () -> Void) {
		self._searchText = searchText
		self._inputStyle = inputStyle
		self.inputIcon = inputIcon
		self.placeHolder = placeHolder
		self.keyboardType = keyboardType
		self.onEditingChanged = onEditingChanged
		self.onCancelHandler = onCancelHandler
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
				TextField(placeHolder, text: $searchText, onEditingChanged: onEditingChanged)
					.onChange(of: searchText) {
						shouldShowCancelButton = $0.count > 0
					}
					.font(font)
					.foregroundColor(textColor)
					.padding(.vertical, Constants.paddingVertical)
					.padding(.trailing, Constants.spacing)
				if shouldShowCancelButton {
					Button(action: onCancelHandler) {
						commonUIConfig.imageSet.closeIcon
							.foregroundColor(tintColor)
							.padding(.trailing, Constants.paddingHorizontal)
					}
				}
			}
			.frame(height: Constants.textFieldHeight)
			.padding()
			.background(backgroundColor)
			.cornerRadius(cornerRadius)
			.overlay(
				RoundedRectangle(cornerRadius: cornerRadius)
					.stroke(borderColor, lineWidth: borderWidth)
			)
		}
	}
}

// MARK: - Private func
private extension SearchTextField {
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
}

struct SearchTextField_Previews: PreviewProvider {
	static var previews: some View {
		SearchTextField(searchText: .constant("Test"), inputStyle: .constant(.error(message: "Error")), placeHolder: "Phone") { _ in } onCancelHandler: {}
	}
}
