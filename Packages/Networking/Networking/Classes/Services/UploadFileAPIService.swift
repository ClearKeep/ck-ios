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
    
    public func uploadFile(_ request: UploadFile_FileUploadRequest) async -> Result<UploadFile_UploadFilesResponse, Error> {
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
    
    public func uploadChunkedFile() async -> Result<UploadFile_UploadFilesResponse, Error> {
        return await withCheckedContinuation({ continuation in
            let response = clientUploadFile.upload_chunked_file().response
            let status = clientUploadFile.upload_chunked_file().status
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
    
    public func getUploadFileLink(_ request: UploadFile_GetUploadFileLinkRequest) async -> Result<UploadFile_GetUploadFileLinkResponse, Error> {
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
    
    public func getDownloadFileLink(_ request: UploadFile_GetDownloadFileLinkRequest) async -> Result<UploadFile_GetDownloadFileLinkResponse, Error> {
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
