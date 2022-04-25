//
//  SearchCatalogy.swift
//  ClearKeep
//
//  Created by MinhDev on 06/04/2022.
//

import SwiftUI

protocol ISearchCatalogy: CaseIterable {
	var title: String { get }
}

extension ISearchCatalogy where Self: RawRepresentable, RawValue == String {
	var title: String {
		self.rawValue
	}
}

enum SearchCatalogy: String, ISearchCatalogy {
	case all = "All"
	case people = "People"
	case group = "Group"
	case message = "Message"
}
