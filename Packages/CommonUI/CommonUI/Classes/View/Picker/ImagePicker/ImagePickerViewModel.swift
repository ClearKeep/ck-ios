//
//  ImagePickerViewModel.swift
//  CommonUI
//
//  Created by Quang Pham on 17/06/2022.
//

import SwiftUI
import Combine
import Photos

final class ImagePickerViewModel: NSObject, ObservableObject, PHPhotoLibraryChangeObserver {
	// MARK: - Properties
	@Published var fetchedImages = [ImageModel]()
	@Published var selectedImages = [ImageModel]()
		
	private var allImages = PHFetchResult<PHAsset>()
	private let imageManager = PHCachingImageManager()
	
	func requestAuthorization() {
		PHPhotoLibrary.requestAuthorization { [weak self] (status) in
			guard let weakSelf = self else { return }
			switch status {
			case .authorized:
				print("PHPhotoLibrary.requestAuthorization: authorized.")
				if weakSelf.fetchedImages.isEmpty {
					weakSelf.setup()
				}
			case .denied:
				print("PHPhotoLibrary.requestAuthorization: denied.")
			case .notDetermined:
				print("PHPhotoLibrary.requestAuthorization: notDetermined.")
			case .restricted:
				print("PHPhotoLibrary.requestAuthorization: restricted.")
			case .limited:
				print("PHPhotoLibrary.requestAuthorization: limited.")
			@unknown default:
				print("PHPhotoLibrary.requestAuthorization: unknown default.")
			}
		}
		
		PHPhotoLibrary.shared().register(self)
	}
	
	func photoLibraryDidChange(_ changeInstance: PHChange) {
		let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
		switch status {
		case .authorized:
			print("PPHPhotoLibrary.requestAuthorization: authorized.")
		case .denied:
			print("PPHPhotoLibrary.requestAuthorization: denied.")
		case .notDetermined:
			print("PPHPhotoLibrary.requestAuthorization: notDetermined.")
		case .restricted:
			print("PPHPhotoLibrary.requestAuthorization: restricted.")
		case .limited:
			print("PPHPhotoLibrary.requestAuthorization: limited.")
		@unknown default:
			print("PPHPhotoLibrary.requestAuthorization: unknown default.")
		}
	}
	
	deinit {
		PHPhotoLibrary.shared().unregisterChangeObserver(self)
	}
	
	private func setup() {
		let options = PHFetchOptions()
		options.sortDescriptors = [
			NSSortDescriptor(key: "creationDate", ascending: false)
		]

		allImages = PHAsset.fetchAssets(with: .image, options: options)
		allImages.enumerateObjects { (asset, _, _) in
			DispatchQueue.main.async { [weak self] in
				self?.fetchedImages.append(ImageModel(asset: asset))
			}
		}
	}
	
	func asyncThumbnail(asset: PHAsset, size: CGSize, completion: @escaping (UIImage?) -> Void) -> UIImage? {
		var syncImageResult: UIImage?
		var hasLoadedImage = false
		
		requestThumbnail(for: asset, thumbnailSize: size) { image, _ in
			DispatchQueue.main.async {
				syncImageResult = image
				
				if !hasLoadedImage || image != nil {
					completion(image)
					
					if image != nil {
						hasLoadedImage = true
					}
				}
			}
		}
		return syncImageResult
	}
	
	private func requestThumbnail(for asset: PHAsset, thumbnailSize: CGSize, resultHandler: @escaping (UIImage?, [AnyHashable: Any]?) -> Void) {
		_ = imageManager.requestImage(for: asset, targetSize: thumbnailSize, contentMode: .aspectFit, options: nil, resultHandler: resultHandler)
	}
	
	func getAssetURL(asset: PHAsset, completion: @escaping (URL?) -> Void) {
		let options = PHContentEditingInputRequestOptions()
		options.isNetworkAccessAllowed = true
		
		let requestId = asset.requestContentEditingInput(with: options) { input, _ in
			if asset.mediaType == .image {
				completion(input?.fullSizeImageURL)
			} else if let url = (input?.audiovisualAsset as? AVURLAsset)?.url {
				completion(url)
			}
		}
	}
}
