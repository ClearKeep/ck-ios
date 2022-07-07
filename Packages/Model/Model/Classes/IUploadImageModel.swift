//
//  IUploadImageModel.swift
//  Model
//
//  Created by MinhDev on 04/07/2022.
//

import Foundation

public protocol IUploadImageModel {
	var fileName: String { get }
	var fileContentType: String { get }
	var fileData: Data { get }
	var fileHash: String { get }
}
