//
//  ImageSelectableView.swift
//  CommonUI
//
//  Created by Quang Pham on 17/06/2022.
//

import SwiftUI

// MARK: Constants
private enum Constants {
	static let iconSize = 32.0
}

struct AssetImageSelectableView: View {
	@Binding var selected: [ImageModel]
	private var select: () -> Void
	
	var asset: ImageModel
	var size: CGSize
	
	init(asset: ImageModel, size: CGSize, selected: Binding<[ImageModel]>, select: @escaping() -> Void) {
		self.size = size
		self.asset = asset
		self._selected = selected
		self.select = select
	}
	
	var body: some View {
		ZStack(alignment: .bottomTrailing) {
			if let thumbnail = asset.thumbnail {
				Image(uiImage: thumbnail)
					.resizable()
					.scaledToFill()
					.aspectRatio(contentMode: .fill)
					.frame(width: size.width, height: size.height)
					.clipped()
			} else {
				ProgressView()
					.frame(width: size.width, height: size.height, alignment: .center)
			}
			Group {
				if selected.contains(self.asset) {
					commonUIConfig.imageSet.checkedIcon
				} else {
					commonUIConfig.imageSet.unCheckIcon
				}
			}.frame(width: Constants.iconSize, height: Constants.iconSize)
				.offset(x: -12, y: -12)
			
			// Needed because of SwiftUI bug with tap area of Image.
			Rectangle()
				.opacity(0.000001)
				.frame(width: size.width, height: size.height)
				.clipped()
				.onTapGesture {
					if let firstIndex = self.selected.firstIndex(of: self.asset) {
						self.selected.remove(at: firstIndex)
					} else {
						self.selected.append(self.asset)
					}
					select()
				}
		}
		.border(commonUIConfig.colorSet.primaryDefault, width: selected.contains(self.asset) ? 2 : 0)
		.frame(width: size.width, height: size.height)
	}
}
