//
//  CatalogySelection.swift
//  ClearKeep
//
//  Created by MinhDev on 07/04/2022.
//

import SwiftUI

struct CatalogySelection: Identifiable {
	var id = UUID()
	var title: String
	var action: () -> Void
}
