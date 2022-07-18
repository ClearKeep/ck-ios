//
//  MessageImageView.swift
//  CommonUI
//
//  Created by Quang Pham on 20/06/2022.
//

import Foundation
import SwiftUI

private enum Constants {
	static let singleWidth = UIScreen.main.bounds.width * 0.54
	static let multipleWidth = UIScreen.main.bounds.width * 0.29
	static let maxImageWidth = UIScreen.main.bounds.width * 0.73
	static let horizontalPadding = 24.0
	static let verticalPadding = 24.0
}

struct MessageImageView: View {
	
	var listImageURL: [String]
	var fromClientName: String
	
	init(listImageURL: [String], fromClientName: String) {
		self.listImageURL = listImageURL
		self.fromClientName = fromClientName
	}
	
	@State var showingGallery = false
	
	var body: some View {
		content
			.onTapGesture {
				showingGallery = true
			}
			.fullScreenCover(isPresented: $showingGallery, content: {
				GalleryView(imageURLs: listImageURL, fromClientName: fromClientName, isShown: $showingGallery)
			})
	}
	
	var content: AnyView {
		switch listImageURL.count {
		case 1:
			return AnyView(oneImageView)
		case 2, 3, 4:
			return AnyView(multipleImageView)
		default:
			return AnyView(limitedMultipleImageView)
		}
	}
	
	private var oneImageView: some View {
		imageView(for: listImageURL.first ?? "", size: Constants.singleWidth)
			.padding(.vertical, Constants.verticalPadding)
			.padding(.horizontal, Constants.horizontalPadding)
	}
	
	private var multipleImageView: some View {
		var columns = Array(repeating: GridItem(.flexible(), spacing: 8), count: 2)
		
		return LazyVGrid(columns: columns, spacing: 8) {
			ForEach(listImageURL, id: \.self) { image in
				imageView(for: image, size: Constants.multipleWidth)
			}
		}.padding(.vertical, Constants.verticalPadding)
			.padding(.horizontal, Constants.horizontalPadding)
			.frame(maxWidth: Constants.maxImageWidth)
	}
	
	private var limitedMultipleImageView: some View {
		var columns = Array(repeating: GridItem(.flexible(), spacing: 8), count: 2)
		
		return LazyVGrid(columns: columns, spacing: 8) {
			ForEach(listImageURL[0...3], id: \.self) { image in
				ZStack {
					imageView(for: image, size: Constants.multipleWidth)
					if listImageURL[3] == image && listImageURL.count > 4 {
						Color.black.opacity(0.3)
							.cornerRadius(16)
							.frame(width: Constants.multipleWidth, height: Constants.multipleWidth)
						Text("+\(notDisplayedImages)")
							.font(commonUIConfig.fontSet.font(style: .display3))
							.foregroundColor(commonUIConfig.colorSet.offWhite)
					}
				}
			}
		}.padding(.vertical, Constants.verticalPadding)
			.padding(.horizontal, Constants.horizontalPadding)
			.frame(maxWidth: Constants.maxImageWidth)
	}
	
	private func imageView(for url: String, size: CGFloat) -> some View {
		CachedAsyncImage(url: URL(string: url)) { phase in
			switch phase {
			case .empty:
				ProgressView()
					.frame(width: size, height: size)
			case .success(let image):
				image
					.resizable()
					.scaledToFill()
					.aspectRatio(contentMode: .fill)
					.frame(width: size, height: size)
					.cornerRadius(16)
					.scaleEffect(1.0001) // Needed because of SwiftUI sometimes incorrectly displaying landscape images.
					.clipped()
			case .failure(let error):
				EmptyView()
					.frame(width: size, height: size)
			}
		}
	}
	
	private var notDisplayedImages: Int {
		listImageURL.count > 4 ? listImageURL.count - 4 : 0
	}
}
