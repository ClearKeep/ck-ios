//
//  SearchCatalogy.swift
//  ClearKeep
//
//  Created by MinhDev on 06/04/2022.
//

import SwiftUI

struct SearchCatalogy: Identifiable {
	let id = UUID()
	let title: String
	let action: () -> Void
}
