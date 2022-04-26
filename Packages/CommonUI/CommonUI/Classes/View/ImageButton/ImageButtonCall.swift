//
//  ImageButtonCall.swift
//  _NIODataStructures
//
//  Created by đông on 26/04/2022.
//

import SwiftUI

private enum Constants {
	static let textHeight = 24.0
	static let spacing = 14.0
	static let paddingHorizontal = 24.0
}

public struct ImageButtonCall: View {
	// MARK: - Variables
	@Binding var isChecked: Bool
	private let image: Image

	// MARK: - Init
	public init(image: Image, isChecked: Binding<Bool>) {
		self.image = image
		self._isChecked = isChecked
	}

	// MARK: - Body
	public var body: some View {
		Button {
			isChecked.toggle()
		} label: {
			image
		}
	}
}
