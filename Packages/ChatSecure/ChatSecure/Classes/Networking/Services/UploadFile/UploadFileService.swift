//
//  UploadFileService.swift
//  ChatSecure
//
//  Created by Quang Pham on 17/06/2022.
//

import Networking
import Common

public protocol IUploadFileService {
	func uploadFile(mimeType: String, fileName: String, fileURL: URL, domain: String) async -> String?
}

public class UploadFileService {
	public init() {
	}
}

extension UploadFileService: IUploadFileService {
	
	public func uploadFile(mimeType: String, fileName: String, fileURL: URL, domain: String) async -> String? {
		let result = await getUploadFileUrl(fileName: fileName, mimeType: mimeType, domain: domain)
		guard let uploadFileLink = result else { return nil }
		guard let uploadFileURL = URL(string: uploadFileLink.uploadedFileURL) else { return nil }
		var urlRequest = URLRequest(url: uploadFileURL)
		urlRequest.httpMethod = "PUT"
		urlRequest.setValue(mimeType, forHTTPHeaderField: "Content-Type")
		do {
			let (_, response) = try await URLSession.shared.upload(for: urlRequest, fromFile: fileURL)
			Debug.DLog("upload file response \(response)")
			let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 0
			return statusCode == 200 ? uploadFileLink.downloadFileURL : nil
		} catch {
			Debug.DLog("uploading file \(fileName) fail - \(error)")
			return nil
		}
	}
}

private extension UploadFileService {
	func getUploadFileUrl(fileName: String, mimeType: String, domain: String) async -> UploadFile_GetUploadFileLinkResponse? {
		var request = UploadFile_GetUploadFileLinkRequest()
		request.fileName = fileName
		request.fileContentType = mimeType
		request.isPublic = true
		
		let response = await channelStorage.getChannel(domain: domain).getUploadFileLink(request)
		
		switch response {
		case .success(let data):
			print(data)
			return data
		case .failure(let error):
			Debug.DLog("Get upload file URL fail - \(error)")
			return nil
		}
	}
}
