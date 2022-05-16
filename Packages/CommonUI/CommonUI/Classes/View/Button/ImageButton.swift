//
//  ImageButton.swift
//  CommonUI
//
//  Created by NamNH on 09/05/2022.
//

import SwiftUI

public struct ImageButton: View {
	// MARK: - Variables
	private let image: Image
	private var action: () -> Void
	
	// MARK: Init
	public init(_ image: Image, action: @escaping() -> Void) {
		self.image = image
		self.action = action
	}
	
	// MARK: - Body
	public var body: some View {
		Button(action: action, label: { image
			.renderingMode(.template)
		})
	}
}
