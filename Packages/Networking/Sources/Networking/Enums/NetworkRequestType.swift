//
//  NetworkRequestType.swift
//  Networking
//
//  Created by NamNH on 03/10/2021.
//

import Alamofire

public enum NetworkRequestType {
	case data
	case upload(MultipartFormData)
	case download
}
