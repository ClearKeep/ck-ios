//
//  ChatGroupModel.swift
//  ClearKeep
//
//  Created by đông on 28/03/2022.
//

import UIKit

protocol IGroupChatModel {
	var id: Int { get }
	var name: String { get }
}

struct GroupChatModel {
	var id: Int
	var name: String
}

extension GroupChatModel: IGroupChatModel {}
