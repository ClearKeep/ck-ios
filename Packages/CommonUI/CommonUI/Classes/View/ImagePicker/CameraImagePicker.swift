//
//  CameraImagePicker.swift
//  CommonUI
//
//  Created by Quang Phạm on 25/06/2022.
//

import SwiftUI
import PhotosUI
import Common

public struct CameraImagePicker: UIViewControllerRepresentable {
	@Environment(\.presentationMode) public var presentationMode
	
	let sourceType: UIImagePickerController.SourceType
	
	var onAssetPicked: (SelectedImageModel) -> Void
	
	public init(sourceType: UIImagePickerController.SourceType, onAssetPicked: @escaping (SelectedImageModel) -> Void) {
		self.sourceType = sourceType
		self.onAssetPicked = onAssetPicked
	}
	
	public func makeUIViewController(context: Context) -> UIImagePickerController {
		let pickerController = UIImagePickerController()
		pickerController.delegate = context.coordinator
		if UIImagePickerController.isSourceTypeAvailable(sourceType) {
			pickerController.sourceType = sourceType
		}
		pickerController.mediaTypes = ["public.image"]
		
		return pickerController
	}
	
	public func updateUIViewController(
		_ uiViewController: UIImagePickerController,
		context: Context
	) { /* Not needed. */ }
	
	public func makeCoordinator() -> CameraImagePickerCoordinator {
		Coordinator(self)
	}
}

public final class CameraImagePickerCoordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	public var parent: CameraImagePicker
	
	public init(_ control: CameraImagePicker) {
		parent = control
	}
	
	public func imagePickerController(
		_ picker: UIImagePickerController,
		didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
	) {
		if let uiImage = info[.originalImage] as? UIImage,
		   let imageURL = try? uiImage.temporaryLocalImageUrl() {
			let addedImage = SelectedImageModel(id: UUID().uuidString, thumbnail: uiImage, url: imageURL)
			parent.onAssetPicked(addedImage)
		}
		
		dismiss()
	}
	
	public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
		dismiss()
	}
	
	public func dismiss() {
		parent.presentationMode.wrappedValue.dismiss()
	}
}
