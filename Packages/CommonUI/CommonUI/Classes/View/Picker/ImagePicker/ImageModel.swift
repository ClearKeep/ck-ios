//
//  ImageModel.swift
//  CommonUI
//
//  Created by Quang Pham on 17/06/2022.
//

import Foundation
import PhotosUI
import SwiftUI

public struct ImageModel: Hashable, Identifiable {
	public var id: String
	public var asset: PHAsset
	public var thumbnail: UIImage?
	public var url: URL?
	
	public init(asset: PHAsset) {
		self.asset = asset
		self.id = asset.localIdentifier
	}
	
	public func toSelectedImageModel() -> SelectedImageModel {
		return SelectedImageModel(id: id, thumbnail: thumbnail, url: url)
	}
}

public struct SelectedImageModel: Hashable, Identifiable {
	public var id: String
	public var thumbnail: UIImage?
	public var url: URL?
}
