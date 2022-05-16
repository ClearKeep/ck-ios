//
//  ServerViewModel.swift
//  ClearKeep
//
//  Created by NamNH on 12/05/2022.
//

import Foundation

struct ServerViewModel: Identifiable {
	var id: Int
	var name: String
	var imageURL: URL?
	var isSelected: Bool = false
}
