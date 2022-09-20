//
//  UploadFileService.swift
//  ChatSecure
//
//  Created by Quang Pham on 17/06/2022.
//

import Networking
import Common

public protocol IUploadFileService {
	func uploadFile(mimeType: String, fileName: String, fileURL: URL, fileSize: Int64, isAppendSize: Bool, domain: String) async -> String?
	func downloadFile(urlString: String) async -> Result<String, Error>
}

public class UploadFileService {
	public init() {
	}
}

extension UploadFileService: IUploadFileService {
	
	public func uploadFile(mimeType: String, fileName: String, fileURL: URL, fileSize: Int64, isAppendSize: Bool, domain: String) async -> String? {
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
			if statusCode == 200 {
				return isAppendSize ? "\(uploadFileLink.downloadFileURL)|\(fileSize)" : uploadFileLink.downloadFileURL
			} else {
				return nil
			}
		} catch {
			Debug.DLog("uploading file \(fileName) fail - \(error)")
			return nil
		}
	}
	
	public func downloadFile(urlString: String) async -> Result<String, Error> {
		Debug.DLog("downloading \(urlString)")
		guard let url = URL(string: urlString),
			  let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
		else { return .failure(ServerError.unknown) }
		
		let destinationUrl = documentsUrl.appendingPathComponent(url.lastPathComponent)
		if FileManager().fileExists(atPath: destinationUrl.path) {
			Debug.DLog("File already exists", destinationUrl.path)
			return .success(destinationUrl.path)
		} else {
			do {
				let (downloadURL, response) = try await URLSession.shared.download(from: url)
				Debug.DLog("download file response \(response)")
				Debug.DLog("download file url \(downloadURL)")
				
				try await FileManager.default.moveItem(at: downloadURL, to: destinationUrl)
				Debug.DLog("download file success to [\(destinationUrl.path)]")
				return .success(destinationUrl.path)
			} catch {
				Debug.DLog("download file \(urlString) fail - \(error)")
				return .failure(error)
			}
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
