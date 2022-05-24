//
//  Server.swift
//  ClearKeep
//
//  Created by NamNH on 12/05/2022.
//

import SwiftUI
import CommonUI

private enum Constants {
	static let imageCache = URLCache(memoryCapacity: 512 * 1000 * 1000, diskCapacity: 10 * 1000 * 1000 * 1000)
	static let cornerRadius = 4.0
	static let padding = 3.0
	static let lineWidth = 1.5
}

struct ServerButton: View {
	// MARK: - Variables
	@Environment(\.colorScheme) var colorScheme
	private let server: ServerViewModel?
	private let image: Image
	private let isSelected: Bool
	private let action: () -> Void
	
	// MARK: Init
	init(_ server: ServerViewModel, isSelected: Bool, action: @escaping() -> Void) {
		self.server = server
		self.image = AppTheme.shared.imageSet.logo
		self.isSelected = isSelected
		self.action = action
	}
	
	init(_ image: Image, isSelected: Bool, action: @escaping() -> Void) {
		self.server = nil
		self.image = image
		self.isSelected = isSelected
		self.action = action
	}
	
	// MARK: - Body
	var body: some View {
		Button(action: action, label: {
			if let imageURL = server?.imageURL {
				CachedAsyncImage(url: imageURL,
								 urlCache: Constants.imageCache,
								 content: { image in image.resizable() },
								 placeholder: { ProgressView() })
				.frame(maxWidth: .infinity, maxHeight: .infinity)
				.cornerRadius(Constants.cornerRadius)
				.padding(Constants.padding)
			} else {
				image
					.renderingMode(.template)
					.resizable()
					.aspectRatio(contentMode: .fit)
					.padding(Constants.padding)
					.frame(maxWidth: .infinity, maxHeight: .infinity)
					.background(LinearGradient(gradient: Gradient(colors: AppTheme.shared.colorSet.gradientLinear),
											   startPoint: .leading,
											   endPoint: .trailing))
					.foregroundColor(AppTheme.shared.colorSet.offWhite)
					.cornerRadius(Constants.cornerRadius)
					.padding(Constants.padding)
			}
		})
		.frame(maxWidth: .infinity, maxHeight: .infinity)
		.if(isSelected, transform: { view in
			view
				.overlay(RoundedRectangle(cornerRadius: Constants.cornerRadius)
					.stroke(colorScheme == .light ? AppTheme.shared.colorSet.black : AppTheme.shared.colorSet.offWhite, lineWidth: Constants.lineWidth))
		})
	}
}
