//
//  UIImageExtension.swift
//  Common
//
//  Created by Quang Phạm on 25/06/2022.
//

import Foundation

public extension UIImage {
	func temporaryLocalImageUrl() throws -> URL? {
		guard let imageData = jpegData(compressionQuality: 1.0) else { return nil }
		let imageName = "\(UUID().uuidString).jpg"
		let documentDirectory = NSTemporaryDirectory()
		let localPath = documentDirectory.appending(imageName)
		let photoURL = URL(fileURLWithPath: localPath)
		try imageData.write(to: photoURL)
		return photoURL
	}
}
