//
//  UploadFileAPIService.swift
//  Networking
//
//  Created by NamNH on 19/04/2022.
//

import Foundation

public protocol IUploadFileAPIService {
	func uploadImage(_ request: UploadFile_FileUploadRequest) async -> Result<UploadFile_UploadFilesResponse, Error>
	func uploadFile(_ request: UploadFile_FileUploadRequest) async -> Result<UploadFile_UploadFilesResponse, Error>
	func uploadChunkedFile() async -> Result<UploadFile_UploadFilesResponse, Error>
	func getUploadFileLink(_ request: UploadFile_GetUploadFileLinkRequest) async -> Result<UploadFile_GetUploadFileLinkResponse, Error>
	func getDownloadFileLink(_ request: UploadFile_GetDownloadFileLinkRequest) async -> Result<UploadFile_GetDownloadFileLinkResponse, Error>
}

extension APIService: IUploadFileAPIService {
	public func uploadImage(_ request: UploadFile_FileUploadRequest) async -> Result<UploadFile_UploadFilesResponse, Error> {
		return await withCheckedContinuation({ continuation in
			let caller = clientUploadFile.upload_image(request, callOptions: callOptions)
			
			caller.status.whenComplete({ result in
				switch result {
				case .success(let status):
					if status.isOk {
						caller.response.whenComplete { result in
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
	
	public func uploadFile(_ request: UploadFile_FileUploadRequest) async -> Result<UploadFile_UploadFilesResponse, Error> {
		return await withCheckedContinuation({ continuation in
			let caller = clientUploadFile.upload_file(request, callOptions: callOptions)
			
			caller.status.whenComplete({ result in
				switch result {
				case .success(let status):
					if status.isOk {
						caller.response.whenComplete { result in
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
	
	public func uploadChunkedFile() async -> Result<UploadFile_UploadFilesResponse, Error> {
		return await withCheckedContinuation({ continuation in
			let caller = clientUploadFile.upload_chunked_file()
			
			caller.status.whenComplete({ result in
				switch result {
				case .success(let status):
					if status.isOk {
						caller.response.whenComplete { result in
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
	
	public func getUploadFileLink(_ request: UploadFile_GetUploadFileLinkRequest) async -> Result<UploadFile_GetUploadFileLinkResponse, Error> {
		return await withCheckedContinuation({ continuation in
			let caller = clientUploadFile.get_upload_file_link(request, callOptions: callOptions)
			
			caller.status.whenComplete({ result in
				switch result {
				case .success(let status):
					if status.isOk {
						caller.response.whenComplete { result in
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
	
	public func getDownloadFileLink(_ request: UploadFile_GetDownloadFileLinkRequest) async -> Result<UploadFile_GetDownloadFileLinkResponse, Error> {
		return await withCheckedContinuation({ continuation in
			let caller = clientUploadFile.get_download_file_link(request, callOptions: callOptions)
			
			caller.status.whenComplete({ result in
				switch result {
				case .success(let status):
					if status.isOk {
						caller.response.whenComplete { result in
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
