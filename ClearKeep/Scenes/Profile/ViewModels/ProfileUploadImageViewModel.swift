//
//  ProfileUploadImageViewModel.swift
//  ClearKeep
//
//  Created by MinhDev on 04/07/2022.
//

import Foundation
import Model

struct ProfileUploadImageViewModel {
	var fileName: String
	var fileContentType: String
	var fileData: Data
	var fileHash: String
	
	init(_ user: IUploadImageModel?) {
		fileName = user?.fileName ?? ""
		fileContentType = user?.fileContentType ?? ""
		fileData = user?.fileData ?? Data()
		fileHash = user?.fileHash ?? ""
	}
}
