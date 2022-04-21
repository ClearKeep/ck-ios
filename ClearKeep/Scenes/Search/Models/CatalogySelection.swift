//
//  CatalogySelection.swift
//  ClearKeep
//
//  Created by MinhDev on 07/04/2022.
//

import SwiftUI

protocol ICatalogySelection {
	var title: String { get }
	var action: () -> Void { get }
}

struct CatalogySelection: Identifiable {
	var id = UUID()
	var title: String
	var action: () -> Void
}

extension CatalogySelection: ICatalogySelection {
}
