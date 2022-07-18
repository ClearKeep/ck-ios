//
//  URLExtensions.swift
//  ChatSecure
//
//  Created by Quang Pham on 17/06/2022.
//

import UniformTypeIdentifiers

extension URL {
	public func mimeType() -> String {
		if let mimeType = UTType(filenameExtension: self.pathExtension)?.preferredMIMEType {
			return mimeType
		} else {
			return "application/octet-stream"
		}
	}
}
