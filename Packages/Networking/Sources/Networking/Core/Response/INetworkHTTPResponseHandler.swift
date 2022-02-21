//
//  INetworkHTTPResponseHandler.swift
//  Networking
//
//  Created by NamNH on 02/10/2021.
//

import Foundation
import Alamofire

public protocol INetworkHTTPResponseHandler {
	func handle(response: AFDataResponse<Data>, completion: @escaping (Result<Data?, Error>) -> Void)
}
