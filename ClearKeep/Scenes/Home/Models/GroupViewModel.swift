//
//  GroupViewModel.swift
//  ClearKeep
//
//  Created by NamNH on 12/05/2022.
//

import Foundation

struct GroupViewModel: Identifiable {
	var id: Int
	var name: String
	var hasNewMessage: Bool = false
}
