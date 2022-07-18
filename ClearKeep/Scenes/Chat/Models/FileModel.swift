//
//  FileModel.swift
//  ClearKeep
//
//  Created by Quang Phạm on 26/06/2022.
//

import Foundation

struct FileModel {
	let url: URL
	let size: Int64
	let mimeType: String
	let name: String
	
	init(url: URL, size: Int64) {
		self.url = url
		self.size = size
		self.mimeType = url.mimeType()
		self.name = url.lastPathComponent
	}
}
