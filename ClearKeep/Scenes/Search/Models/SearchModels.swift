//
//  SearchModels.swift
//  ClearKeep
//
//  Created by MinhDev on 22/04/2022.
//

import UIKit
import SwiftUI

protocol ISearchModels {
	var id: Int { get }
	var imageUser: Image { get }
	var userName: String { get }
	var message: String { get }
	var groupText: String { get }
	var dateMessage: String { get }
}

struct SearchModels {
	var id: Int
	var imageUser: Image
	var userName: String
	var message: String
	var groupText: String
	var dateMessage: String
}

extension SearchModels: ISearchModels {
}
