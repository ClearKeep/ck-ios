//
//  SearchCatalogy.swift
//  ClearKeep
//
//  Created by MinhDev on 06/04/2022.
//

import SwiftUI

protocol ISearchCatalogy {
	var title: String { get }
}

enum SearchCatalogy: ISearchCatalogy {
	case all
	case people
	case group
	case message

	var title: String {
		switch self {
		case .all:
			return "Search.All".localized.uppercased()
		case .people:
			return "Search.People".localized.uppercased()
		case .group:
			return "Search.GroupChat".localized.uppercased()
		case .message:
			return "Search.Message".localized.uppercased()
		}
	}
}
