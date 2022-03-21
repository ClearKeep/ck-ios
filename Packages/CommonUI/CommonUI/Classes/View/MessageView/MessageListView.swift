//
//  MessageListView.swift
//  ClearKeep
//
//  Created by Nguyễn Nam on 5/24/21.
//

import SwiftUI

struct MessageListView<Content: View>: View {
	// MARK: - Variables
	private var listMessageAndSection: [SectionWithMessageViewModel] = []
	
	// MARK: - Constants
	private let content: (MessageDisplayInfoViewModel) -> Content
	
	// MARK: - Init
	init(messages: [IMessageViewModel], @ViewBuilder content: @escaping (MessageDisplayInfoViewModel) -> Content) {
		self.content = content
		self.setupList(messages)
	}
	
	// MARK: - Setup
	private mutating func setupList(_ messages: [IMessageViewModel]) {
		listMessageAndSection = []
	}
	
	// MARK: - Body
	var body: some View {
		VStack(spacing: 8) {
			ForEach(listMessageAndSection, id: \.title) { group in
				Section(header: Text(group.title ?? "")
							.font(commonUIConfig.fontSet.font(style: .input2))
							.foregroundColor(commonUIConfig.colorSet.grey3)) {
					let listDisplayMessage = MessageUtils.getListRectCorner(messages: group.messages)
					ForEach(listDisplayMessage, id: \.message.id) { message in
						content(message)
					}
				}
			}
		}
		.padding([.horizontal, .bottom])
		.padding(.top, 25)
	}
}
