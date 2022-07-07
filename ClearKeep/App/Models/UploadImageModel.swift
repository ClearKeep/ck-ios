//
//  UploadImageModel.swift
//  ClearKeep
//
//  Created by MinhDev on 04/07/2022.
//

import Model
import ChatSecure
import Networking

struct UploadImageModel: IUploadImageModel {
	var fileName: String
	var fileContentType: String
	var fileData: Data
	var fileHash: String
}
