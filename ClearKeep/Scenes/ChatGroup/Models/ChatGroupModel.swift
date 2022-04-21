//
//  ChatGroupModel.swift
//  ClearKeep
//
//  Created by đông on 28/03/2022.
//

import UIKit

protocol IGroupChatModel {
//	var id: Int { get }
//	var title: String { get }
}

struct GroupChatModel: Identifiable {
	var id = UUID()
	var name: String
}

extension GroupChatModel: IGroupChatModel {}
