//
//  SwiftUIView.swift
//  
//
//  Created by MinhDev on 09/03/2022.
//

import SwiftUI

private enum Constants {
	static let textHeight = 24.0
	static let spacing = 14.0
	static let paddingHorizontal = 24.0
}

public struct CheckBoxButtons: View {
	// MARK: - Variables
	@Binding var checked: Bool
	private let text: String
	// MARK: - Init
	public init(text: String,
				checked: Binding<Bool>) {
		self.text = text
		self._checked = checked
	}
	// MARK: - Body
	public var body: some View {
		Button(action: {
			checked.toggle()
		}, label: {
			HStack {
			Image(systemName: checked ? "checkmark.circle" : "checkmark.circle.fill")
				.foregroundColor(focegroundColorImage)
			Text(text)
				.font(font)
				.frame(height: Constants.textHeight)
			}
		}
	)}
}
// MARK: - Private func
private extension CheckBoxButtons {
	var focegroundColorImage: Color {
		checked ? commonUIConfig.colorSet.primaryDark : commonUIConfig.colorSet.grey3
	}
	
	var font: Font {
		commonUIConfig.fontSet.font(style: .body3)
	}
}
struct CheckBoxButtons_Previews: PreviewProvider {
	static var previews: some View {
		CheckBoxButtons(text: ("Test"), checked: .constant(false))
	}
}
