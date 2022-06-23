//
//  UserPeerButton.swift
//  CommonUI
//
//  Created by MinhDev on 17/06/2022.
//

import SwiftUI

private enum Constants {
	static let imageCache = URLCache(memoryCapacity: 512 * 1000 * 1000, diskCapacity: 10 * 1000 * 1000 * 1000)
	static let cornerRadius = 4.0
	static let padding = 3.0
	static let lineWidth = 1.5
	static let imageSize = CGSize(width: 60.0, height: 60.0)
	static let spacing = 16.0
}

public struct UserPeerButton: View {
	// MARK: - Variables
	
	@Environment(\.colorScheme) var colorScheme
	@Binding var title: String
	private var imageUrl: URL?
	private var action: () -> Void
	
	// MARK: Init
	public init(_ title: Binding<String>, imageUrl: String, action: @escaping() -> Void) {
		self._title = title
		self.action = action
		self.imageUrl = URL(string: imageUrl)
	}
	
	init(_ title: Binding<String>, action: @escaping() -> Void) {
		self.imageUrl = nil
		self._title = title
		self.action = action
	}
	
	// MARK: - Body
	public var body: some View {
		Button(action: action, label: {
			if let imageURL = imageUrl {
				HStack(spacing: Constants.spacing) {
					if #available(iOS 15.0, *) {
						CachedAsyncImage(url: imageURL,
										 urlCache: Constants.imageCache,
										 content: { image in image.resizable() },
										 placeholder: { ProgressView() })
							.frame(maxWidth: .infinity, maxHeight: .infinity)
							.cornerRadius(Constants.cornerRadius)
							.padding(Constants.padding)
					} else {
						// Fallback on earlier versions
					}
					Text(title)
						.frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
						.font(commonUIConfig.fontSet.font(style: .body2))
						.foregroundColor(foregroundTitle)
						.lineLimit(2)
				}
			} else {
				HStack(spacing: Constants.spacing) {
					ZStack {
						Circle()
							.fill(backgroundColor)
							.frame(width: Constants.imageSize.width, height: Constants.imageSize.height)
						Text(title.capitalized.prefix(1))
							.foregroundColor(commonUIConfig.colorSet.offWhite)
							.font(commonUIConfig.fontSet.font(style: .display3))
					}
					Text(title)
						.frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
						.font(commonUIConfig.fontSet.font(style: .body2))
						.foregroundColor(foregroundTitle)
				}
			}
		})
		.frame(maxWidth: .infinity, maxHeight: .infinity)	}
}

// MARK: - Private Variables
private extension UserPeerButton {
	var backgroundColor: LinearGradient {
		LinearGradient(gradient: Gradient(colors: commonUIConfig.colorSet.gradientPrimary), startPoint: .leading, endPoint: .trailing)
	}
	
	var foregroundTitle: Color {
		colorScheme == .light ? commonUIConfig.colorSet.grey2 : commonUIConfig.colorSet.greyLight
	}
	
}
