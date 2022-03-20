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
	@Binding var isChecked: Bool
	private let text: String

	// MARK: - Init
	public init(text: String, isChecked: Binding<Bool>) {
		self.text = text
		self._isChecked = isChecked
	}
	// MARK: - Body
	public var body: some View {
		Button(action: {
			isChecked.toggle()
		}, label: {
			HStack {
			checkMaskIcon
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
		isChecked ? commonUIConfig.colorSet.primaryDark : commonUIConfig.colorSet.grey3
	}
	
	var font: Font {
		commonUIConfig.fontSet.font(style: .body3)
	}

	var checkMaskIcon: Image {
		isChecked ? commonUIConfig.imageSet.checkMask : commonUIConfig.imageSet.checkMaskFill
	}
}

struct CheckBoxButtons_Previews: PreviewProvider {
	static var previews: some View {
		CheckBoxButtons(text: ("Test"), isChecked: .constant(false))
	}
}
