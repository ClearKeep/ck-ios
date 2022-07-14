//
//  PreviewImage.swift
//  ClearKeep
//
//  Created by Quang Pham on 17/06/2022.
//

import SwiftUI

private enum Constants {
	static let radius = 16.0
	static let sizeImage = 56.0
	static let sizeCircle = 20.0
	static let sizeIcon = 10.0
}

public struct PreviewImage: View {
	// MARK: - Variables
	private let image: UIImage
	private var onClosed: () -> Void
	
	// MARK: - Init
	public init(image: UIImage, onClosed: @escaping () -> Void) {
		self.image = image
		self.onClosed = onClosed
	}
	
	// MARK: - Body
	public var body: some View {
		ZStack(alignment: .topTrailing) {
			Image(uiImage: image)
				.resizable()
				.frame(width: Constants.sizeImage, height: Constants.sizeImage)
				.cornerRadius(Constants.radius)
			Button(action: onClosed) {
				ZStack {
					Circle()
						.frame(width: Constants.sizeCircle, height: Constants.sizeCircle)
					AppTheme.shared.imageSet.crossIcon
						.resizable()
						.frame(width: Constants.sizeIcon, height: Constants.sizeIcon)
						.foregroundColor(AppTheme.shared.colorSet.offWhite)
				}.foregroundColor(AppTheme.shared.colorSet.primaryDefault)
			}.offset(x: 1, y: -2)
		}
	}
}
