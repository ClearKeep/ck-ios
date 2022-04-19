//
//  UploadFileAPIService.swift
//  Networking
//
//  Created by NamNH on 19/04/2022.
//

import Foundation

protocol IUploadFileAPIService {
	func uploadImage(_ request: UploadFile_FileUploadRequest) async -> Result<UploadFile_UploadFilesResponse, Error>
	func uploadFile(_ request: UploadFile_FileUploadRequest) async -> Result<UploadFile_UploadFilesResponse, Error>
	func uploadChunkedFile() async
	func getUploadFileLink(_ request: UploadFile_GetUploadFileLinkRequest) async -> Result<UploadFile_GetUploadFileLinkResponse, Error>
	func getDownloadFileLink(_ request: UploadFile_GetDownloadFileLinkRequest) async -> Result<UploadFile_GetDownloadFileLinkResponse, Error>
}

extension APIService: IUploadFileAPIService {
	func uploadImage(_ request: UploadFile_FileUploadRequest) async -> Result<UploadFile_UploadFilesResponse, Error> {
		return await withCheckedContinuation({ continuation in
			let response = clientUploadFile.upload_image(request).response
			let status = clientUploadFile.upload_image(request).status
			status.whenComplete({ result in
				switch result {
				case .success(let status):
					if status.isOk {
						response.whenComplete { result in
							continuation.resume(returning: result)
						}
					} else {
						continuation.resume(returning: .failure(ServerError(status)))
					}
				case .failure(let error):
					continuation.resume(returning: .failure(ServerError(error)))
				}
			})
		})
	}
	
	func uploadFile(_ request: UploadFile_FileUploadRequest) async -> Result<UploadFile_UploadFilesResponse, Error> {
		return await withCheckedContinuation({ continuation in
			let response = clientUploadFile.upload_file(request).response
			let status = clientUploadFile.upload_file(request).status
			status.whenComplete({ result in
				switch result {
				case .success(let status):
					if status.isOk {
						response.whenComplete { result in
							continuation.resume(returning: result)
						}
					} else {
						continuation.resume(returning: .failure(ServerError(status)))
					}
				case .failure(let error):
					continuation.resume(returning: .failure(ServerError(error)))
				}
			})
		})
	}
	
	func uploadChunkedFile() async {
		
	}
	
	func getUploadFileLink(_ request: UploadFile_GetUploadFileLinkRequest) async -> Result<UploadFile_GetUploadFileLinkResponse, Error> {
		return await withCheckedContinuation({ continuation in
			let response = clientUploadFile.get_upload_file_link(request).response
			let status = clientUploadFile.get_upload_file_link(request).status
			status.whenComplete({ result in
				switch result {
				case .success(let status):
					if status.isOk {
						response.whenComplete { result in
							continuation.resume(returning: result)
						}
					} else {
						continuation.resume(returning: .failure(ServerError(status)))
					}
				case .failure(let error):
					continuation.resume(returning: .failure(ServerError(error)))
				}
			})
		})
	}
	
	func getDownloadFileLink(_ request: UploadFile_GetDownloadFileLinkRequest) async -> Result<UploadFile_GetDownloadFileLinkResponse, Error> {
		return await withCheckedContinuation({ continuation in
			let response = clientUploadFile.get_download_file_link(request).response
			let status = clientUploadFile.get_download_file_link(request).status
			status.whenComplete({ result in
				switch result {
				case .success(let status):
					if status.isOk {
						response.whenComplete { result in
							continuation.resume(returning: result)
						}
					} else {
						continuation.resume(returning: .failure(ServerError(status)))
					}
				case .failure(let error):
					continuation.resume(returning: .failure(ServerError(error)))
				}
			})
		})
	}
}
