//
//  SectionWithMessageViewModel.swift
//  
//
//  Created by NamNH on 20/03/2022.
//

import Foundation
import SwiftUI

public protocol ISectionWithMessageViewModel {
	var title: String? { get }
	var messages: [IMessageViewModel] { get }
}

public struct SectionWithMessageViewModel {
	public let title: String?
	public let messages: [IMessageViewModel]
	
	public init(title: String? = nil, messages: [IMessageViewModel]) {
		self.title = title
		self.messages = messages
	}
}

extension SectionWithMessageViewModel: ISectionWithMessageViewModel {
}
